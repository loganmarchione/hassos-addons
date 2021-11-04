# prometheus_node_exporter

The Prometheus [Node Exporter](https://github.com/prometheus/node_exporter) for hardware and OS metrics exposed by *NIX kernels.

## Installation

1. Search for the "Prometheus Node Exporter" add-on in the Supervisor add-on store and install it.
1. Disable "Protection mode" in the add-on panel.
1. Start the add-on.
1. Check the logs of the add-on to see if everything went well.
1. To verify the metrics are available, visit `http://your_home_assistant_ip_address:9100/metrics` in your browser, or use curl `curl -X GET http://your_home_assistant_ip_address:9100/metrics`.

## Configuration

## Usage

Add the following to your `/etc/prometheus/prometheus.yml` config file on your Prometheus server:

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

## Authors & contributors

## License
