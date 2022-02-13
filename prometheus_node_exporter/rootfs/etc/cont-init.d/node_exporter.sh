#!/usr/bin/with-contenv bashio
# ==============================================================================
# Home Assistant Community Add-on: Prometheus Node Exporter
# Configures Prometheus Node Exporter
# ==============================================================================
bashio::require.unprotected
echo "${SUPERVISOR_TOKEN}" > '/run/home-assistant.token'

# Even if the user isn't using these options, we're creating the web config file
# This will allow us to append to the web config file as needed (based on variables)
# Node_exporter will run with a blank web config file in the meantime
web_config_file=/etc/prometheus_node_exporter_web.yml
touch $web_config_file
chmod 740 $web_config_file
chown root:prometheus $web_config_file

# Poor man's debugger: check permissions on web config file
#ls -la $web_config_file

bashio::log.info "Checking configuration options..."

#####################
# HTTP Basic Auth
#####################

if bashio::config.false 'enable_basic_auth'; then
  bashio::log.warning "HTTP Basic Auth is disabled!"
fi

if bashio::config.true 'enable_basic_auth'; then
  bashio::log.info "HTTP Basic Auth is enabled!"

  # Require variables
  bashio::config.require 'basic_auth_user' "You enabled HTTP Basic Auth, so you must set a username"
  bashio::config.require 'basic_auth_pass' "You enabled HTTP Basic Auth, so you must set a password"
  basic_auth_user="$(bashio::config 'basic_auth_user')"
  basic_auth_pass="$(bashio::config 'basic_auth_pass')"

  # Blank out web config file
  rm $web_config_file

  # Start echoing lines out to web config file (YAML is space-sensitive so I'm lazily not using a heredoc)
  echo "basic_auth_users:" > $web_config_file
  echo "    $basic_auth_user: $basic_auth_pass" >> $web_config_file

  # Poor man's debugger: check web config file
  #cat $web_config_file
fi

#####################
# TLS
# TODO
#####################
