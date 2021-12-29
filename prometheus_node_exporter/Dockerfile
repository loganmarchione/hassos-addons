ARG BUILD_FROM
FROM $BUILD_FROM

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Setup base system
ARG BUILD_ARCH=amd64
ENV NODE_EXPORTER_VERSION=1.3.1

# Copy root filesystem
COPY rootfs /

RUN \
    ARCH="${BUILD_ARCH}" \
    && if [ "${BUILD_ARCH}" = "aarch64" ]; then ARCH="arm64"; fi \
    && curl -J -L -o /tmp/node_exporter.tar.gz \
       "https://github.com/prometheus/node_exporter/releases/download/v${NODE_EXPORTER_VERSION}/node_exporter-${NODE_EXPORTER_VERSION}.linux-${ARCH}.tar.gz" \
    && cd /tmp \
    && tar -xvf /tmp/node_exporter.tar.gz \
    && cp node_exporter-${NODE_EXPORTER_VERSION}.linux-${ARCH}/node_exporter /usr/local/bin/ \
    && adduser -s /bin/false -D -H prometheus \
    && chown -R prometheus:prometheus /usr/local/bin/node_exporter \
    && rm -f -r /tmp/*

# Build arguments
ARG BUILD_DATE
ARG BUILD_REF
ARG BUILD_VERSION
