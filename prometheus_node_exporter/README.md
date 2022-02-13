# prometheus_node_exporter

The Prometheus [Node Exporter](https://github.com/prometheus/node_exporter) for hardware and OS metrics exposed by *NIX kernels.

## Installation

1. Add my [repository](https://github.com/loganmarchione/hassos-addons). The URL is `https://github.com/loganmarchione/hassos-addons`.
2. Search for the "Prometheus Node Exporter" add-on in the Supervisor add-on store and install it.
3. Disable "Protection mode" in the add-on panel.
4. Start the add-on.
5. Check the logs of the add-on to see if everything went well.
6. To verify the metrics are available, visit `http://your_home_assistant_ip_address:9100/metrics` in your browser, or use curl `curl -X GET http://your_home_assistant_ip_address:9100/metrics`.

## Configuration

N/A

## Usage

Add the following to the `/etc/prometheus/prometheus.yml` config file on your Prometheus server:

    scrape_configs:
      ...
      ...
      ...
      - job_name: 'homeassistant'
        static_configs:
        - targets: ['your_home_assistant_ip_address:9100']

The following Prometheus query should return data:

    node_uname_info{job="homeassistant"}

## Support

- Tested on `amd64` and `aarch64` (Raspberry Pi 4B) platforms

## Authors & contributors

[Logan Marchione](https://github.com/loganmarchione)

## License

WIP

## Known issues

- [ ] The "Open Web UI" button doesn't work when Home Assistant is behind a reverse proxy.
- [X] Only tested on `amd64` builds.

## TODO

- [ ] Add HTTP Basic Auth
- [ ] Add TLS

## FAQ

- Doesn't Home Assistant already have Prometheus integration?
    - Yes, but the [official integration](https://www.home-assistant.io/integrations/prometheus/) only exposes entity-related metrics, not host-related metrics.
- Isn't there already an Prometheus add-on?
    - Yes, but that [add-on](https://github.com/hassio-addons/addon-prometheus) is for Prometheus server, not the node exporter.
- Why does this add-on require so many permissions?
    - The add-on needs to access to host-level metrics (CPU, memory, disk, etc...). As such, I have requested all possible permissions. Please inspect the code of this add-on before you run it.
