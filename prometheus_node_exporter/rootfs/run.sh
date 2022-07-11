#!/usr/bin/env bashio
# ==============================================================================
# Home Assistant Community Add-on: Prometheus Node Exporter
# Runs the Prometheus Node Exporter
# ==============================================================================
#
# WHAT IS THIS FILE?!
#
# The Prometheus Node Exporter add-on runs in the host PID namespace, therefore it cannot
# use the regular S6-Overlay; hence this add-on uses a "old school" script
# to run; with a couple of "hacks" to make it work.
# ==============================================================================
/etc/cont-init.d/node_exporter.sh

# Start Prometheus Node Exporter
exec /etc/services.d/node_exporter/run