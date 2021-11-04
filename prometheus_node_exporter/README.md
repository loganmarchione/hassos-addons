# prometheus_node_exporter

The Prometheus [Node Exporter](https://github.com/prometheus/node_exporter) for hardware and OS metrics exposed by *NIX kernels.

## Installation

1. Search for the "Prometheus Node Exporter" add-on in the Supervisor add-on store and install it.
1. Disable "Protection mode" in the add-on panel.
1. Start the add-on.
1. Check the logs of the add-on to see if everything went well.
1. To verify the metrics are available, use curl.
```
curl -X GET http://your_home_assistant_ip_address:9100/metrics \
  -H 'Authorization: Bearer your_access_token_goes_here'
```

## Configuration

## Usage


## Support

## Authors & contributors

## License