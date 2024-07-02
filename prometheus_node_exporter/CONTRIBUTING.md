# Contributing

## Making changes

Currently, this repo pushes a tagged image from `main` to the [packages](https://github.com/users/loganmarchione/packages?repo_name=hassos-addons) tab each time `main` is updated. As such, if you're proposing a change, please update the following files in a PR and DO NOT push directly to `main`.

1. Bump the `version` number in the [config.json](https://github.com/loganmarchione/hassos-addons/blob/main/prometheus_node_exporter/config.json) file
1. Make whatever changes you need (e.g., bumping the [version of Node Exporter](https://github.com/loganmarchione/hassos-addons/blob/main/prometheus_node_exporter/Dockerfile) or the [version of the base images](https://github.com/loganmarchione/hassos-addons/blob/main/prometheus_node_exporter/build.json))
1. Add your changes to the [CHANGELOG.md](https://github.com/loganmarchione/hassos-addons/blob/main/prometheus_node_exporter/CHANGELOG.md) file

## Testing

I'm still working this out, but am doing testing based on [this page](https://developers.home-assistant.io/docs/add-ons/testing).

After making your changes, run the command below from the git root directory (i.e., `hassos-addons`) to ensure that the add-on builds successfully (substitute `amd64` with `armhf`, `aarch64`, or `i386` based on your system).

```
docker run \
  --rm \
  -it \
  --name builder \
  --privileged \
  -v ./prometheus_node_exporter:/data \
  -v /var/run/docker.sock:/var/run/docker.sock:ro \
  ghcr.io/home-assistant/amd64-builder \
  -t /data \
  --amd64 \
  --test \
  -i test-prometheus-node-exporter \
  -d local
```

To test that the add-on actually runs, I've been using my personal instance of Home Assistant 🤷‍♂️

1. Open the Add-ons panel in Home Assistant by going to `Settings-->Add-ons-->Add-on Store`
1. Uninstall the current Prometheus Node Exporter add-on (the one published from GHCR.io)
1. Install the official [samba add-on](https://github.com/home-assistant/addons/tree/master/samba)
1. Enable samba with a username and password
1. Mount the samba share locally (e.g., Dolphin can use `smb://your_home_assistant_ip_address`)
1. Navigate to the `addons` directory in the samba share
1. Copy/paste the entire `prometheus_node_exporter` directory to the `addons` directory in the samba share
1. In the `config.json` file in the samba share, remove this entire line
   ```
   "image": "ghcr.io/loganmarchione/hassos-addons/prometheusnodeexporter-{arch}",
   ```
1. Open the Add-ons panel in Home Assistant by going to `Settings-->Add-ons-->Add-on Store`
1. Click the menu icon in the top-right, then click "Check for updates"
1. Refresh the page
1. At the very top, there should be a new section for "Local add-ons" with the "Prometheus Node Exporter" to install
1. Install the new add-on from the local repository
   1. Test all configurations
   1. Make sure log entries line up with configuration settings
   1. Navigate to `http://your_home_assistant_ip_address:9100/metrics` and ensure that HTTP basic auth works as expected
1. Stop and uninstall the local add-on
1. Delete the entire `prometheus_node_exporter` directory in the `addons` directory in the samba share
1. Disable the samba add-on
1. Re-install add-on from GHCR.io (you'll need to re-configure the add-on)