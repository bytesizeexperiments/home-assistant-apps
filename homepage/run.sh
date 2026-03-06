#!/usr/bin/env bash

# Load bashio functions manually
source /usr/lib/bashio/bashio.sh

# Path setup
CONFIG_DIR="/addon_config"
INTERNAL_CONFIG="/app/config"

bashio::log.info "Checking for existing Homepage configuration..."

# Create persistent directory
mkdir -p "$CONFIG_DIR"

# Ensure internal app folder exists
mkdir -p /app

# Seed default files from image if they don't exist in HA storage
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

# Map the internal app folder to the persistent HA folder
rm -rf "$INTERNAL_CONFIG"
ln -s "$CONFIG_DIR" "$INTERNAL_CONFIG"

# Determine Node path and start
NODE_BIN=$(which node || echo "/usr/local/bin/node")
bashio::log.info "Starting Homepage server..."

cd /app
exec "$NODE_BIN" src/server.js