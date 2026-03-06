# Use a more specific, verified base image for the architecture
ARG BUILD_FROM=ghcr.io/gethomepage/homepage:latest
FROM $BUILD_FROM

ENV CACHE_DATE=2026-03-06-v5

LABEL \
  io.hass.name="Homepage" \
  io.hass.description="Packaged by Byte Size Experiments" \
  io.hass.type="addon"

# Install basics
RUN apk add --no-cache curl bash jq findutils

# Install bashio
RUN curl -J -L -o /tmp/bashio.tar.gz https://github.com/hassio-addons/bashio/archive/v0.16.2.tar.gz \
    && mkdir -p /tmp/bashio \
    && tar zxvf /tmp/bashio.tar.gz --strip 1 -C /tmp/bashio \
    && mv /tmp/bashio/lib /usr/lib/bashio \
    && ln -sf /usr/lib/bashio/bashio /usr/bin/bashio \
    && rm -rf /tmp/bashio.tar.gz /tmp/bashio

WORKDIR /app
ENV NODE_ENV=production

COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]