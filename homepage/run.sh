#!/usr/bin/env bash

# Load bashio functions
source /usr/lib/bashio/bashio.sh

CONFIG_DIR="/addon_config"
INTERNAL_CONFIG="/app/config"
SETTINGS_FILE="$CONFIG_DIR/settings.yaml"

bashio::log.info "Checking for existing Homepage configuration..."
mkdir -p "$CONFIG_DIR"
mkdir -p /app

# Seed default files if they don't exist
for file in settings.yaml services.yaml widgets.yaml bookmarks.yaml docker.yaml; do
    if [ ! -f "$CONFIG_DIR/$file" ]; then
        if [ -f "$INTERNAL_CONFIG/$file" ]; then
            cp "$INTERNAL_CONFIG/$file" "$CONFIG_DIR/$file"
        else
            touch "$CONFIG_DIR/$file"
        fi
    fi
done

# --- DYNAMIC AUTOMATION BLOCK ---
bashio::log.info "Dynamically detecting Ingress slug..."

# Get the slug automatically from the Supervisor API via bashio
SLUG=$(bashio::addon.slug)
INGRESS_BASE="/api/hassio_ingress/${SLUG}/"

bashio::log.info "Detected slug: ${SLUG}. Setting base to ${INGRESS_BASE}"

# Remove any existing 'base:' lines to avoid duplicates
sed -i '/^base:/d' "$SETTINGS_FILE"

# Prepend the correct dynamic base path to the top of settings.yaml
echo "base: ${INGRESS_BASE}" | cat - "$SETTINGS_FILE" > temp && mv temp "$SETTINGS_FILE"
# ----------------------------

# Link the persistent HA folder
rm -rf "$INTERNAL_CONFIG"
ln -s "$CONFIG_DIR" "$INTERNAL_CONFIG"

bashio::log.info "Starting Homepage..."
cd /app
exec node server.js