ARG BUILD_FROM=ghcr.io/home-assistant/base:3.23
FROM ${BUILD_FROM}

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

LABEL \
  org.opencontainers.image.authors="Logan Marchione <logan@loganmarchione.com>" \
  org.opencontainers.image.title="Prometheus Node Exporter" \
  org.opencontainers.image.description="The Prometheus Node Exporter for hardware and OS metrics exposed by *NIX kernels." \
  org.opencontainers.image.source="https://github.com/loganmarchione/hassos-addons/tree/main/prometheus_node_exporter"

# Setup base system
ARG NODE_EXPORTER_VERSION="1.11.1"
ARG TARGETARCH

# hadolint ignore=DL3003,DL3018
RUN \
    if [ -z "${TARGETARCH}" ]; then \
        echo "TARGETARCH is not set, please use Docker BuildKit for the build." && exit 1; \
    fi \
    && case "${TARGETARCH}" in \
        amd64) NODE_EXPORTER_ARCH="amd64" ;; \
        arm64) NODE_EXPORTER_ARCH="aarch64" ;; \
        *) echo "Unsupported TARGETARCH: ${TARGETARCH}" && exit 1 ;; \
    esac \
    && mkdir -p /tmp/node_exporter \
    && curl -sSLf -o /tmp/node_exporter/node_exporter.tar.gz \
       "https://github.com/prometheus/node_exporter/releases/download/v${NODE_EXPORTER_VERSION}/node_exporter-${NODE_EXPORTER_VERSION}.linux-${NODE_EXPORTER_ARCH}.tar.gz" \
    && cd /tmp/node_exporter \
    && tar -xzvf node_exporter.tar.gz --strip-components=1 \
    && mv node_exporter /usr/local/bin/ \
    && adduser -s /bin/false -D -H prometheus \
    && chown -R prometheus:prometheus /usr/local/bin/node_exporter \
    && cd /tmp \
    && rm -rf /tmp/node_exporter

# Copy root filesystem
COPY rootfs /

# This add-on runs on the host pid namespace, making it impossible
# to use S6-Overlay. Therefore the init system is disabled at this point.
ENTRYPOINT []
CMD ["/run.sh"]
