ARG BUILD_FROM=ghcr.io/gethomepage/homepage:latest
FROM $BUILD_FROM

# Switch to root to install bashio and set permissions
USER root

# Install requirements
RUN apk add --no-cache curl bash jq

# Install bashio
RUN curl -J -L -o /tmp/bashio.tar.gz https://github.com/hassio-addons/bashio/archive/v0.16.2.tar.gz \
    && mkdir -p /tmp/bashio \
    && tar zxvf /tmp/bashio.tar.gz --strip 1 -C /tmp/bashio \
    && mv /tmp/bashio/lib /usr/lib/bashio \
    && ln -sf /usr/lib/bashio/bashio /usr/bin/bashio \
    && rm -rf /tmp/bashio.tar.gz /tmp/bashio

WORKDIR /app

# Copy the new startup script
COPY run.sh /
RUN chmod a+x /run.sh

# Ensure the /app and /addon_config directories are manageable
RUN mkdir -p /addon_config && chown -R root:root /app /addon_config

# Stay as root so run.sh can write to the persistent volume
USER root

CMD [ "/run.sh" ]