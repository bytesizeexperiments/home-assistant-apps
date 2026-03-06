#!/usr/bin/env bash

# Load bashio functions manually since we aren't using the HA base image
source /usr/lib/bashio/bashio.sh

# HA Maps addon_config to /addon_config in the container
CONFIG_DIR="/addon_config"
INTERNAL_CONFIG="/app/config"

bashio::log.info "Checking for existing Homepage configuration..."

# Create directory in persistent storage if it doesn't exist
mkdir -p "$CONFIG_DIR"

# Seed default YAML files from the image if they don't exist in persistent storage
for file in settings.yaml services.yaml widgets.yaml bookmarks.yaml docker.yaml; do
    if [ ! -f "$CONFIG_DIR/$file" ]; then
        bashio::log.info "Seeding default $file..."
        # If the file exists in the original image, copy it; otherwise, create an empty one
        if [ -f "$INTERNAL_CONFIG/$file" ]; then
            cp "$INTERNAL_CONFIG/$file" "$CONFIG_DIR/$file"
        else
            touch "$CONFIG_DIR/$file"
        fi
    fi
done

# Remove the internal config directory and link it to the persistent HA folder
rm -rf "$INTERNAL_CONFIG"
ln -s "$CONFIG_DIR" "$INTERNAL_CONFIG"

bashio::log.info "Starting Homepage on internal port 3000..."

# Execute the original entrypoint of the Homepage image
exec npm start