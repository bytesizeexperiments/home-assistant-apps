ARG BUILD_FROM=ghcr.io/home-assistant/aarch64-base:latest
FROM $BUILD_FROM

# Force a fresh build
ENV CACHE_DATE=2026-03-06-final-v2

# 1. Install system dependencies including git and node
RUN apk add --no-cache \
    curl bash jq nodejs npm git

# 2. Clone the actual Homepage source code and install it
WORKDIR /app
RUN git clone --depth 1 https://github.com/gethomepage/homepage.git . \
    && npm install --production

# 3. Install bashio for Home Assistant logging/config
RUN curl -J -L -o /tmp/bashio.tar.gz https://github.com/hassio-addons/bashio/archive/v0.16.2.tar.gz \
    && mkdir -p /tmp/bashio \
    && tar zxvf /tmp/bashio.tar.gz --strip 1 -C /tmp/bashio \
    && mv /tmp/bashio/lib /usr/lib/bashio \
    && ln -sf /usr/lib/bashio/bashio /usr/bin/bashio \
    && rm -rf /tmp/bashio.tar.gz /tmp/bashio

# Ensure Homepage knows where its config is
ENV HOMEPAGE_CONFIG_DIR=/app/config
ENV NODE_ENV=production

COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]