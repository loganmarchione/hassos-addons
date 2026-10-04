# Contributing

## Making changes

Please propose changes in a PR and DO NOT push directly to `main`. In your PR, update the following files:

1. Bump the `version` number in the [config.json](https://github.com/loganmarchione/hassos-addons/blob/main/prometheus_node_exporter/config.json) file
1. Make whatever changes you need (e.g., bumping the version of Node Exporter or the version of the base images) in the [Dockerfile](https://github.com/loganmarchione/hassos-addons/blob/main/prometheus_node_exporter/Dockerfile)
1. Add your changes to the [CHANGELOG.md](https://github.com/loganmarchione/hassos-addons/blob/main/prometheus_node_exporter/CHANGELOG.md) file

## Releasing

Merging to `main` does NOT publish anything. Images are only built and pushed to the [packages](https://github.com/users/loganmarchione/packages?repo_name=hassos-addons) tab when a tag in the format `<addon>/v<version>` is pushed.

After the PR is merged, tag `main` with the version from `config.json` and push the tag:

```
git checkout main
git pull
git tag prometheus_node_exporter/v1.2.3
git push origin prometheus_node_exporter/v1.2.3
```

The [Build](https://github.com/loganmarchione/hassos-addons/blob/main/.github/workflows/build.yaml) workflow will fail if the tag version doesn't match the `version` in `config.json`. If it succeeds, it publishes `amd64` and `aarch64` images, plus a multi-arch manifest, to GHCR.

## Testing

### Automated (GitHub Actions)

These run on every PR to `main`, on every push to `main`, and weekly:

- [Lint](https://github.com/loganmarchione/hassos-addons/blob/main/.github/workflows/lint.yaml) runs the Home Assistant add-on linter and runs `shellcheck` on `test.sh`
- [Test](https://github.com/loganmarchione/hassos-addons/blob/main/.github/workflows/test.yaml) runs `test.sh` (see below)

### Locally (test.sh)

Before opening a PR, run the test script. It can be run from any directory.

```
./prometheus_node_exporter/test.sh
```

Requirements: Docker with `buildx`, `curl`, and `file`. The non-native architecture (e.g., `arm64` on an `amd64` machine) runs under QEMU, which the script registers automatically (this requires running a privileged container). The images are built from scratch without cache, so expect it to take a few minutes.

For both `amd64` and `arm64`, the script checks that:

- The image builds
- The `node_exporter` binary matches the target architecture
- `bashio`, `htpasswd`, and the `prometheus` user exist in the image
- `node_exporter` starts, rejects unauthenticated requests (HTTP 401), and serves `/metrics` with HTTP basic auth
- The running `node_exporter` version matches `NODE_EXPORTER_VERSION` in the Dockerfile

The script does NOT test the add-on inside Home Assistant. Specifically, it doesn't run `run.sh` or the scripts in `rootfs/`, it doesn't test add-on options (e.g., `enable_basic_auth`, `enable_tls`, `cmdline_extra_args`) or TLS, and it doesn't test anything in `config.json`. For changes to any of those, or to the base image, test in Home Assistant (see below).

### In Home Assistant

I'm doing this testing based on [this page](https://developers.home-assistant.io/docs/add-ons/testing). To test that the add-on actually runs, I've been using my personal instance of Home Assistant 🤷‍♂️

1. Open the Add-ons panel in Home Assistant by going to `Settings-->Add-ons-->Add-on Store`
1. Uninstall the current Prometheus Node Exporter add-on (the one published from GHCR.io)
1. Install the official [samba add-on](https://github.com/home-assistant/addons/tree/master/samba)
1. Enable samba with a username and password
1. Mount the samba share locally (e.g., Dolphin can use `smb://your_home_assistant_ip_address`)
1. Navigate to the `addons` directory in the samba share
1. Copy/paste the entire `prometheus_node_exporter` directory to the `addons` directory in the samba share
1. In the `config.json` file in the samba share, remove this entire line (this makes Home Assistant build the add-on locally instead of pulling it from GHCR.io)
   ```
   "image": "ghcr.io/loganmarchione/hassos-addons/prometheusnodeexporter",
   ```
1. Open the Add-ons panel in Home Assistant by going to `Settings-->Add-ons-->Add-on Store`
1. Click the menu icon in the top-right, then click "Check for updates"
1. Refresh the page
1. At the very top, there should be a new section for "Local add-ons" with the "Prometheus Node Exporter" to install
1. Install the new add-on from the local repository
   1. Test all configurations (including HTTP basic auth, TLS, and extra command-line arguments)
   1. Make sure log entries line up with configuration settings
   1. Navigate to `http://your_home_assistant_ip_address:9100/metrics` (or `https://` if TLS is enabled) and ensure that HTTP basic auth works as expected
1. Stop and uninstall the local add-on
1. Delete the entire `prometheus_node_exporter` directory in the `addons` directory in the samba share
1. Disable the samba add-on
1. Re-install add-on from GHCR.io (you'll need to re-configure the add-on)