# Contributing

## Making changes

Currently, this repo pushes a tagged image from `main` to the [packages](https://github.com/users/loganmarchione/packages?repo_name=hassos-addons) tab each time `main` is updated. As such, if you're proposing a change, please update the following files in a PR and DO NOT push directly to `main`.

1. Bump the `version` number in the [config.json](https://github.com/loganmarchione/hassos-addons/blob/main/prometheus_node_exporter/config.json) file
1. Make whatever changes you need (e.g., bumping the [version of Node Exporter](https://github.com/loganmarchione/hassos-addons/blob/main/prometheus_node_exporter/Dockerfile) or the [version of the base images](https://github.com/loganmarchione/hassos-addons/blob/main/prometheus_node_exporter/build.json))
1. Add your changes to the [CHANGELOG.md](https://github.com/loganmarchione/hassos-addons/blob/main/prometheus_node_exporter/CHANGELOG.md) file

## Testing

I'm still working this out, but am doing testing based on [this page](https://developers.home-assistant.io/docs/add-ons/testing).

After making your changes, run the command below from the git root directory (i.e., `hassos-addons`) to ensure that the add-on builds (substitute `amd64` with `armhf`, `aarch64`, or `i386` based on your system)

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
  --all \
  --test \
  -i test-prometheus-node-exporter \
  -d local
```
