ARG BUILD_FROM=ghcr.io/gethomepage/homepage:latest
FROM $BUILD_FROM

USER root

# Optional tools
RUN apk add --no-cache bash curl jq

# Link HA persistent storage to Homepage config
RUN rm -rf /app/config && ln -s /addon_config /app/config

# Use upstream CMD: node server.js
