#!/usr/bin/env bash
source /usr/lib/bashio/bashio.sh

# 1. Setup paths
HA_CONFIG_DIR="/addon_config"
TMP_CONFIG_DIR="/tmp/homepage_config"
mkdir -p "$HA_CONFIG_DIR"
mkdir -p "$TMP_CONFIG_DIR"

# 2. Get the Dynamic Slug
SLUG=$(curl -s -X GET \
    -H "Authorization: Bearer ${SUPERVISOR_TOKEN}" \
    -H "Content-Type: application/json" \
    http://supervisor/addons/self/info | jq -r '.data.slug')

INGRESS_BASE="/api/hassio_ingress/${SLUG}/"
bashio::log.info "Setting Ingress base to ${INGRESS_BASE}"

# 3. Create the settings file in TMP first
echo "base: ${INGRESS_BASE}" > "${TMP_CONFIG_DIR}/settings.yaml"

# 4. Copy everything from TMP to the actual HA folder
# This forces the files onto the persistent storage
cp -r ${TMP_CONFIG_DIR}/* ${HA_CONFIG_DIR}/

# 5. Tell Homepage to look at the HA folder
export HOMEPAGE_CONFIG_DIR="${HA_CONFIG_DIR}"

bashio::log.info "Starting Homepage..."
cd /app
exec node server.js