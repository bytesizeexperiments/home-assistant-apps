#!/usr/bin/env bash

# 1. Manually set the PATH to include common Node.js locations
export PATH=$PATH:/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin

# Load bashio functions
source /usr/lib/bashio/bashio.sh

# HA Maps addon_config to /addon_config in the container
CONFIG_DIR="/addon_config"
INTERNAL_CONFIG="/app/config"

bashio::log.info "Checking for existing Homepage configuration..."

mkdir -p "$CONFIG_DIR"
mkdir -p /app

# Seed default YAML files
for file in settings.yaml services.yaml widgets.yaml bookmarks.yaml docker.yaml; do
    if [ ! -f "$CONFIG_DIR/$file" ]; then
        if [ -f "$INTERNAL_CONFIG/$file" ]; then
            bashio::log.info "Seeding default $file from image..."
            cp "$INTERNAL_CONFIG/$file" "$CONFIG_DIR/$file"
        else
            bashio::log.info "Creating empty $file..."
            touch "$CONFIG_DIR/$file"
        fi
    fi
done

# Link the persistent HA folder
rm -rf "$INTERNAL_CONFIG"
ln -s "$CONFIG_DIR" "$INTERNAL_CONFIG"

# 2. Final verification and startup
NODE_BIN=$(command -v node)
bashio::log.info "Starting Homepage using node found at: $NODE_BIN"

cd /app
exec "$NODE_BIN" src/server.js