#!/usr/bin/env bash

# Load bashio functions
source /usr/lib/bashio/bashio.sh

CONFIG_DIR="/addon_config"
SETTINGS_FILE="$CONFIG_DIR/settings.yaml"

bashio::log.info "Checking for existing Homepage configuration..."
mkdir -p "$CONFIG_DIR"

# --- DYNAMIC SLUG DETECTION ---
bashio::log.info "Dynamically detecting Ingress slug..."

SLUG=$(curl -s -X GET \
    -H "Authorization: Bearer ${SUPERVISOR_TOKEN}" \
    -H "Content-Type: application/json" \
    http://supervisor/addons/self/info | jq -r '.data.slug')

if [ -z "$SLUG" ] || [ "$SLUG" == "null" ]; then
    SLUG=$(hostname)
fi

INGRESS_BASE="/api/hassio_ingress/${SLUG}/"
bashio::log.info "Detected slug: ${SLUG}. Setting base to ${INGRESS_BASE}"

# Ensure settings.yaml exists and remove old base lines
touch "$SETTINGS_FILE"
sed -i '/^base:/d' "$SETTINGS_FILE"

# Prepend the correct dynamic base path
echo "base: ${INGRESS_BASE}" | cat - "$SETTINGS_FILE" > temp && mv temp "$SETTINGS_FILE"
# ------------------------------

# --- THE FIX ---
# Instead of symlinks, we tell Homepage EXACTLY where to look
export HOMEPAGE_CONFIG_DIR="/addon_config"

bashio::log.info "Starting Homepage..."
cd /app
exec node server.js