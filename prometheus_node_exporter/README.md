# prometheus_node_exporter

[![CI](https://github.com/loganmarchione/hassos-addons/actions/workflows/main.yml/badge.svg)](https://github.com/loganmarchione/hassos-addons/actions/workflows/main.yml)

The Prometheus [Node Exporter](https://github.com/prometheus/node_exporter) for hardware and OS metrics exposed by \*NIX kernels.

## Installation

1. Add my [repository](https://github.com/loganmarchione/hassos-addons). The URL is `https://github.com/loganmarchione/hassos-addons`.
1. Search for the "Prometheus Node Exporter" add-on in the Supervisor add-on store and install it.
1. Disable "Protection mode" in the add-on panel.
1. Optional - Check the `Configuration` tab of the add-on to make any changes you'd like.
1. Start the add-on.
1. Check the `Logs` tab of the add-on to see if everything went well.
1. To verify the metrics are available, visit `http://your_home_assistant_ip_address:9100/metrics` in your browser, or use curl: `curl -X GET http://your_home_assistant_ip_address:9100/metrics`.

## Configuration

By default, Prometheus Node Exporter listens on TCP port 9100.

### HTTP Basic Authentication

[HTTP Basic Auth](https://en.wikipedia.org/wiki/Basic_access_authentication) is disabled by default. If you want to enable HTTP Basic Auth:

1. set `enable_basic_auth` to true
1. enter the `basic_auth_user` and `basic_auth_pass`

⚠️ Note that the `basic_auth_pass` needs to be a [bcrypt password hash](https://prometheus.io/docs/guides/basic-auth/)! ⚠️

The default credentials are below ⚠️ PLEASE CHANGE THEM ⚠️:

```
Username            prom
Password (plain)    prometheus123@
Password (bcrypt)   $2a$12$Azy3nrjebl.U17DLmpX57.cUUKzm/PX5thtAkf7xl/hUHSJrm4VkS
```

### TLS

TLS is disabled by default. If you want to enable TLS:

1. set `enable_tls` to true
1. enter the `cert_file` and `cert_key`

⚠️ Note that the `cert_file` and `cert_key` need to be a `/path/to/fullchain.pem` and `/path/to/privkey.pem`, respectively (`/config` and `/ssl` are mapped to this add-on) ⚠️

### Command-line arguments

This option allows you to pass command-line arguments directly to Prometheus Node Exporter. This is particularly useful to adjust which [collectors](https://github.com/prometheus/node_exporter/#collectors) run. For example, to disable all collectors except the `cpu` collector, you can use this string: `--collector.disable-defaults --collector.cpu`.

## Usage (in Prometheus server)

Add the following to the `/etc/prometheus/prometheus.yml` config file on your Prometheus server:

```
scrape_configs:
  ...
  ...
  ...
  - job_name: 'homeassistant'
    static_configs:
    - targets: ['your_home_assistant_ip_address:9100']
```

The following Prometheus query should return data:

```
node_uname_info{job="homeassistant"}
```

## Support

- Tested on `amd64` and `aarch64` (Raspberry Pi 4B) platforms

## License

WIP

## Known issues

- [ ] The "Open Web UI" button doesn't work when Home Assistant is behind a reverse proxy.
- [x] Only tested on `amd64` builds.

## TODO

- [x] Add HTTP Basic Auth
- [ ] Add abilty to enter plain-text password instead of bcyrpt-ed hash
- [x] Add TLS
- [ ] Per [this comment](https://community.home-assistant.io/t/hello-world-example-addon-from-developer-docs-stopped-working-s6-overlay-issue/421486/7), setup container images on a registry (DockerHub or GitHub) so that users aren't building the container with each install (would have prevented [this issue](https://github.com/loganmarchione/hassos-addons/issues/2))
- [x] Investigate CI/CD for this repo, specifically [this](https://github.com/home-assistant/actions) and [this](https://github.com/hassio-addons/addon-glances/blob/main/.github/workflows/ci.yaml) as an example
- [ ] Investigate dropping API access (e.g., `hassio_api`, `homeassistant_api`, `auth_api`) in order to get my rating up

## FAQ

- Doesn't Home Assistant already have Prometheus integration?
  - Yes, but the [official integration](https://www.home-assistant.io/integrations/prometheus/) only exposes entity-related metrics, not host-related metrics.
- Isn't there already an Prometheus add-on?
  - Yes, but that [add-on](https://github.com/hassio-addons/addon-prometheus) is for Prometheus server, not the node exporter.
- Why does this add-on require so many permissions?
  - The add-on needs to access to host-level metrics (CPU, memory, disk, etc...). As such, I have requested all possible permissions. Please inspect the code of this add-on before you run it.
