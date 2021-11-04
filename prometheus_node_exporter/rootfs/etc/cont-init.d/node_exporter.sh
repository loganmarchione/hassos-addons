#!/usr/bin/with-contenv bashio
# ==============================================================================
# Home Assistant Community Add-on: Prometheus Node Exporter
# Configures Prometheus Node Exporter
# ==============================================================================
bashio::require.unprotected
echo "${SUPERVISOR_TOKEN}" > '/run/home-assistant.token'
