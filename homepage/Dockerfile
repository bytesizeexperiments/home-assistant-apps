ARG BUILD_FROM=gethomepage/homepage:latest
FROM $BUILD_FROM

LABEL \
  io.hass.name="Homepage" \
  io.hass.description="Packaged by Byte Size Experiments" \
  io.hass.type="addon" \
  org.opencontainers.image.authors="Byte Size Experiments" \
  org.opencontainers.image.source="https://github.com/gethomepage/homepage"

# We only need to add curl for healthchecks or script needs; 
# bashio is already present in HA base images.
RUN apk add --no-cache curl

COPY run.sh /
RUN chmod a+x /run.sh

# Use standard ENTRYPOINT to execute our wrapper script
ENTRYPOINT [ "/run.sh" ]