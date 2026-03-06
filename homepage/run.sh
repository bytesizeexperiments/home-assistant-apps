#!/usr/bin/env bash

# Load bashio functions manually
source /usr/lib/bashio/bashio.sh

# HA Maps addon_config to /addon_config in the container
CONFIG_DIR="/addon_config"
INTERNAL_CONFIG="/app/config"

bashio::log.info "Checking for existing Homepage configuration..."

# Create persistent directory if it doesn't exist
mkdir -p "$CONFIG_DIR"

# Ensure the internal /app directory exists (where the app code lives)
mkdir -p /app

# Seed default YAML files if they don't exist in /addon_config
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

# Remove any existing internal config and link it to the persistent HA folder
rm -rf "$INTERNAL_CONFIG"
ln -s "$CONFIG_DIR" "$INTERNAL_CONFIG"

bashio::log.info "Starting Homepage server..."

# Navigate to the app directory and start the server directly with node
cd /app
exec node src/server.js