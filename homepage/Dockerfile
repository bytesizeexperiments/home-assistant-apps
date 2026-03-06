ARG BUILD_FROM=gethomepage/homepage:latest
FROM $BUILD_FROM

LABEL \
  io.hass.name="Homepage" \
  io.hass.description="Packaged by Byte Size Experiments" \
  io.hass.type="addon" \
  org.opencontainers.image.authors="Byte Size Experiments" \
  org.opencontainers.image.source="https://github.com/gethomepage/homepage"

# Install bashio (HA helper)
RUN apk add --no-cache curl \
    && curl -J -L -o /tmp/bashio.tar.gz https://github.com/hassio-addons/bashio/archive/v0.16.2.tar.gz \
    && mkdir /tmp/bashio \
    && tar zxvf /tmp/bashio.tar.gz --strip 1 -C /tmp/bashio \
    && mv /tmp/bashio/lib /usr/lib/bashio \
    && ln -s /usr/lib/bashio/bashio /usr/bin/bashio

COPY run.sh /
RUN chmod a+x /run.sh

ENTRYPOINT [ "/run.sh" ]
