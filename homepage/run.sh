#!/usr/bin/with-contenv bashio

# HA Maps addon_config to /addon_config in the container
CONFIG_DIR="/addon_config"
INTERNAL_CONFIG="/app/config"

bashio::log.info "Checking for existing Homepage configuration..."

# Create directory if it doesn't exist
mkdir -p "$CONFIG_DIR"

# Seed default YAML files if they don't exist
for file in settings.yaml services.yaml widgets.yaml bookmarks.yaml docker.yaml; do
    if [ ! -f "$CONFIG_DIR/$file" ]; then
        bashio::log.info "Seeding default $file..."
        # We copy from the official image's skeleton folder
        cp "$INTERNAL_CONFIG/$file" "$CONFIG_DIR/$file" || touch "$CONFIG_DIR/$file"
    fi
done

# Link the internal app folder to our persistent HA folder
rm -rf "$INTERNAL_CONFIG"
ln -s "$CONFIG_DIR" "$INTERNAL_CONFIG"

bashio::log.info "Starting Homepage on internal port 3000..."
exec npm start
