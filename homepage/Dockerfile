ARG BUILD_FROM=gethomepage/homepage:latest
FROM $BUILD_FROM

# Professional Labels
LABEL \
  io.hass.name="Homepage" \
  io.hass.description="Packaged by Byte Size Experiments" \
  io.hass.type="addon" \
  org.opencontainers.image.authors="Byte Size Experiments" \
  org.opencontainers.image.source="https://github.com/gethomepage/homepage"

# Install bash/jq for bashio functions
RUN apk add --no-cache curl bash jq

# Install bashio
RUN curl -J -L -o /tmp/bashio.tar.gz https://github.com/hassio-addons/bashio/archive/v0.16.2.tar.gz \
    && mkdir -p /tmp/bashio \
    && tar zxvf /tmp/bashio.tar.gz --strip 1 -C /tmp/bashio \
    && mv /tmp/bashio/lib /usr/lib/bashio \
    && ln -sf /usr/lib/bashio/bashio /usr/bin/bashio \
    && rm -rf /tmp/bashio.tar.gz /tmp/bashio

# Set production environment
ENV NODE_ENV=production
ENV HOMEPAGE_CONFIG_DIR=/app/config

WORKDIR /app

COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]