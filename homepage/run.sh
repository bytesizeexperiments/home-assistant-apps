#!/usr/bin/env bash
source /usr/lib/bashio/bashio.sh

HA_CONFIG_DIR="/addon_config"
bashio::log.info "Checking for existing Homepage configuration..."

# 1. Get the Dynamic Slug for Ingress
SLUG=$(curl -s -X GET \
    -H "Authorization: Bearer ${SUPERVISOR_TOKEN}" \
    -H "Content-Type: application/json" \
    http://supervisor/addons/self/info | jq -r '.data.slug')

INGRESS_BASE="/api/hassio_ingress/${SLUG}/"
bashio::log.info "Setting Ingress base to ${INGRESS_BASE}"

# 2. Ensure the directory and settings.yaml exist
mkdir -p "$HA_CONFIG_DIR"
if [ ! -f "$HA_CONFIG_DIR/settings.yaml" ]; then
    touch "$HA_CONFIG_DIR/settings.yaml"
fi

# 3. Use sed to update or add the base line without wiping the file
if grep -q "base:" "$HA_CONFIG_DIR/settings.yaml"; then
    sed -i "s|base:.*|base: ${INGRESS_BASE}|" "$HA_CONFIG_DIR/settings.yaml"
else
    echo "base: ${INGRESS_BASE}" >> "$HA_CONFIG_DIR/settings.yaml"
fi

# 4. Point Homepage to the persistent directory
export HOMEPAGE_CONFIG_DIR="$HA_CONFIG_DIR"

bashio::log.info "Starting Homepage..."
cd /app
exec node server.js