#!/usr/bin/env bash
#
# Builds the Prometheus Node Exporter add-on image and smoke-tests it
# on amd64 and arm64.
#
# Usage (from anywhere):
#   ./prometheus_node_exporter/test.sh
#
# Non-native architectures run under QEMU, which is registered automatically
# if needed.
#
# This does NOT exercise run.sh or cont-init.d (they need the
# Supervisor); test changes to rootfs/ in Home Assistant.

set -euo pipefail

ADDON_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
IMAGE="local/prometheus_node_exporter"
AUTH_USER="test"
AUTH_PASS="test-password"
ARCHES=(amd64 arm64)

# Expected `file` output and binfmt_misc name for each architecture
declare -A FILE_ARCH=([amd64]="x86-64" [arm64]="ARM aarch64")
declare -A QEMU_ARCH=([amd64]="x86_64" [arm64]="aarch64")

TMP="$(mktemp -d)"
CONTAINERS=()
cleanup() {
  for c in "${CONTAINERS[@]}"; do docker rm -f "$c" >/dev/null 2>&1 || true; done
  for arch in "${ARCHES[@]}"; do docker rmi -f "$IMAGE:test-$arch" >/dev/null 2>&1 || true; done
  rm -rf "$TMP"
}
trap cleanup EXIT

log() {
  local message="$1"
  echo "$(date +'%Y-%m-%d %H:%M:%S') - $message"
}

fail() {
  local message="$1"
  echo "$(date +'%Y-%m-%d %H:%M:%S') - FAIL: $message" >&2
  exit 1
}

# curl prints 000 and exits non-zero when it can't connect; keep the 000
http_code() { curl -s -o /dev/null -w '%{http_code}' "$@" || true; }

native_arch() {
  case "$(uname -m)" in
    x86_64) echo amd64 ;;
    aarch64 | arm64) echo arm64 ;;
    *) uname -m ;;
  esac
}

ensure_emulation() {
  local arch=$1
  [[ "$arch" == "$(native_arch)" ]] && return 0
  if [[ ! -e "/proc/sys/fs/binfmt_misc/qemu-${QEMU_ARCH[$arch]}" ]]; then
    log "Registering QEMU emulation for $arch"
    docker run --privileged --rm tonistiigi/binfmt --install "$arch" >/dev/null
  fi
}

test_arch() {
  local arch=$1
  local tag="$IMAGE:test-$arch"
  local platform="linux/$arch"
  local cid desc hash port url code metrics version

  ensure_emulation "$arch"

  log "[$arch] Building $tag"
  docker buildx build --no-cache --platform "$platform" --load -t "$tag" "$ADDON_DIR"

  log "[$arch] Checking binary architecture"
  cid=$(docker create --platform "$platform" "$tag")
  docker cp "$cid:/usr/local/bin/node_exporter" "$TMP/node_exporter-$arch" >/dev/null
  docker rm "$cid" >/dev/null
  desc=$(file -b "$TMP/node_exporter-$arch")
  [[ "$desc" == *"${FILE_ARCH[$arch]}"* ]] || fail "[$arch] node_exporter is the wrong architecture: $desc"
  log "ok: $desc"

  log "[$arch] Checking runtime dependencies used by rootfs/"
  docker run --rm --platform "$platform" --entrypoint sh "$tag" -c \
    'command -v bashio && command -v htpasswd && id prometheus' >/dev/null \
    || fail "[$arch] missing bashio, htpasswd, or the prometheus user"
  log "ok: bashio, htpasswd, and prometheus user present"

  log "[$arch] Starting node_exporter with basic auth"
  # Same hashing approach as cont-init.d/node_exporter.sh (lower cost for speed under QEMU)
  hash=$(docker run --rm --platform "$platform" --entrypoint htpasswd "$tag" \
    -bnBC 10 "" "$AUTH_PASS" | tr -d ':\n')
  printf 'basic_auth_users:\n    %s: %s\n' "$AUTH_USER" "$hash" > "$TMP/web-$arch.yml"

  # Random host port so this doesn't collide with a real node_exporter on 9100
  cid=$(docker run -d --platform "$platform" -p 127.0.0.1::9100 \
    -v "$TMP/web-$arch.yml:/web.yml:ro" \
    --entrypoint /usr/local/bin/node_exporter "$tag" --web.config.file=/web.yml)
  CONTAINERS+=("$cid")
  port=$(docker port "$cid" 9100/tcp | head -n1 | awk -F: '{print $NF}')
  url="http://127.0.0.1:$port/metrics"

  for _ in $(seq 1 30); do
    code=$(http_code "$url")
    [[ "$code" != "000" ]] && break
    sleep 1
  done

  if [[ "$code" != "401" ]]; then
    docker logs "$cid" >&2 || true
    fail "[$arch] expected HTTP 401 without credentials, got $code"
  fi
  log "ok: unauthenticated request rejected (401)"

  if ! metrics=$(curl -fsS -u "$AUTH_USER:$AUTH_PASS" "$url"); then
    docker logs "$cid" >&2 || true
    fail "[$arch] /metrics failed with valid credentials"
  fi
  log "ok: authenticated request succeeded"

  # Match the `version` label specifically (not `goversion`)
  version=$(sed -n 's/^node_exporter_build_info{.*[{,]version="\([^"]*\)".*/\1/p' <<<"$metrics")
  [[ "$version" == "$EXPECTED_VERSION" ]] \
    || fail "[$arch] expected node_exporter $EXPECTED_VERSION, got '${version:-none}'"
  log "ok: node_exporter_build_info version=$version"

  docker rm -f "$cid" >/dev/null
}

# check requirements
for cmd in docker curl file; do
  command -v "$cmd" >/dev/null || fail "'$cmd' is required"
done
docker buildx version >/dev/null 2>&1 || fail "docker buildx is required"

# read NODE_EXPORTER_VERSION from the Dockerfile
EXPECTED_VERSION=$(awk -F= '/^ARG NODE_EXPORTER_VERSION=/ { gsub(/"/, "", $2); print $2; exit }' "$ADDON_DIR/Dockerfile")
[[ -n "$EXPECTED_VERSION" ]] || fail "could not read NODE_EXPORTER_VERSION from Dockerfile"
log "Expecting node_exporter $EXPECTED_VERSION"

for arch in "${ARCHES[@]}"; do
  printf '\n################################################################################\n# Starting tests for %s\n################################################################################\n' "$arch"
  test_arch "$arch"
done

log "All checks passed: ${ARCHES[*]}"