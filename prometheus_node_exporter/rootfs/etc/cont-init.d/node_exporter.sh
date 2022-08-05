#!/usr/bin/env bashio
# ==============================================================================
# Home Assistant Community Add-on: Prometheus Node Exporter
# Configures Prometheus Node Exporter
# ==============================================================================
bashio::require.unprotected
echo "${SUPERVISOR_TOKEN}" > '/run/home-assistant.token'

# Even if the user isn't using these options, we're creating the web config file
# This will allow us to append to the web config file as needed (based on variables)
# Prometheus Node Exporter will run with a blank web config file in the meantime

config_dir=/config
web_config_dir=$config_dir/prometheus_node_exporter
mkdir -p $web_config_dir
chmod 750 $web_config_dir
chown root:prometheus $web_config_dir

web_config_file=$web_config_dir/node_exporter_web.yml
rm -f $web_config_file
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

  # Start echoing lines out to web config file (YAML is space-sensitive so I'm lazily not using a heredoc)
  echo "basic_auth_users:" >> $web_config_file
  echo "    $basic_auth_user: $basic_auth_pass" >> $web_config_file

fi

#####################
# TLS
#####################

if bashio::config.false 'enable_tls'; then
  bashio::log.warning "TLS is disabled!"
fi

if bashio::config.true 'enable_tls'; then
  bashio::log.info "TLS is enabled!"

  # Require variables
  bashio::config.require 'cert_file' "You enabled TLS, so you must set certificate file"
  bashio::config.require 'cert_key' "You enabled TLS, so you must set certificate key"
  cert_file="$(bashio::config 'cert_file')"
  cert_key="$(bashio::config 'cert_key')"

  # Start echoing lines out to web config file (YAML is space-sensitive so I'm lazily not using a heredoc)
  echo "tls_server_config:" >> $web_config_file
  echo "    cert_file: $cert_file" >> $web_config_file
  echo "    key_file: $cert_key" >> $web_config_file

fi
