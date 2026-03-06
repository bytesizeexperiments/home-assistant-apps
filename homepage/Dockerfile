ARG BUILD_FROM=ghcr.io/gethomepage/homepage:latest
FROM $BUILD_FROM

# Add bashio requirements
RUN apk add --no-cache curl bash jq

# Install bashio
RUN curl -J -L -o /tmp/bashio.tar.gz https://github.com/hassio-addons/bashio/archive/v0.16.2.tar.gz \
    && mkdir -p /tmp/bashio \
    && tar zxvf /tmp/bashio.tar.gz --strip 1 -C /tmp/bashio \
    && mv /tmp/bashio/lib /usr/lib/bashio \
    && ln -sf /usr/lib/bashio/bashio /usr/bin/bashio \
    && rm -rf /tmp/bashio.tar.gz /tmp/bashio

# Use the internal path the official image expects
WORKDIR /app
COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]