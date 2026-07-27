# Setup base system
# renovate: datasource=github-releases depName=prometheus/node_exporter
ARG NODE_EXPORTER_VERSION="1.11.1"
ARG TARGETARCH="amd64"
ARG BUILD_FROM=ghcr.io/home-assistant/base:3.22

FROM quay.io/prometheus/node-exporter-linux-${TARGETARCH}:v${NODE_EXPORTER_VERSION} AS exporter

FROM ${BUILD_FROM}

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

LABEL \
  org.opencontainers.image.authors="Logan Marchione <logan@loganmarchione.com>" \
  org.opencontainers.image.title="Prometheus Node Exporter" \
  org.opencontainers.image.description="The Prometheus Node Exporter for hardware and OS metrics exposed by *NIX kernels." \
  org.opencontainers.image.source="https://github.com/loganmarchione/hassos-addons/tree/main/prometheus_node_exporter"

# hadolint ignore=DL3003,DL3018
RUN \
    apk add --no-cache --update apache2-utils \
    && adduser -s /bin/false -D -H prometheus

# Copy root filesystem
COPY rootfs /

COPY --from=exporter /bin/node_exporter /usr/local/bin/node_exporter

# This add-on runs on the host pid namespace, making it impossible
# to use S6-Overlay. Therefore the init system is disabled at this point.
ENTRYPOINT []
CMD ["/run.sh"]
