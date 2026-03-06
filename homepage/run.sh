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

# Remove any existing internal config and link it to the persistent HA folder
rm -rf "$INTERNAL_CONFIG"
ln -s "$CONFIG_DIR" "$INTERNAL_CONFIG"

bashio::log.info "Starting Homepage..."

# Since we installed npm in the Dockerfile, we can use the standard start command
cd /app
exec npm start