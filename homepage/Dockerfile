ARG BUILD_FROM=gethomepage/homepage:latest
FROM $BUILD_FROM

# Change CACHE_DATE to force a fresh pull of the base image
ENV CACHE_DATE=2026-03-06-v4

# Labels...
LABEL \
  io.hass.name="Homepage" \
  io.hass.description="Packaged by Byte Size Experiments" \
  io.hass.type="addon"

# Install bash/jq for bashio
RUN apk add --no-cache curl bash jq

# Install bashio
RUN curl -J -L -o /tmp/bashio.tar.gz https://github.com/hassio-addons/bashio/archive/v0.16.2.tar.gz \
    && mkdir -p /tmp/bashio \
    && tar zxvf /tmp/bashio.tar.gz --strip 1 -C /tmp/bashio \
    && mv /tmp/bashio/lib /usr/lib/bashio \
    && ln -sf /usr/lib/bashio/bashio /usr/bin/bashio \
    && rm -rf /tmp/bashio.tar.gz /tmp/bashio

# Crucial: Ensure the container's node path is preserved
ENV PATH="/usr/local/bin:/usr/bin:${PATH}"
WORKDIR /app

COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]