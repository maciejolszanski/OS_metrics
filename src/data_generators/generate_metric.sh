#!/usr/bin/env bash
set -euo pipefail

# Load environment variables from .env if available
if [ -f .env ]; then
    set -o allexport
    source .env
    set +o allexport
fi

# Strictly validate all required environment variables
if [ -z "${RAW_METRICS_PATH:-}" ] || [ -z "${TMP_DIR:-}" ] || [ -z "${TELEGRAF_TEMPLATE_PATH:-}" ]; then
    echo "Error: Required environment variables (RAW_METRICS_PATH, TMP_DIR, TELEGRAF_TEMPLATE_PATH) are missing in .env." >&2
    exit 1
fi

REAL_CONFIG_PATH="${TMP_DIR}/telegraf_config.conf"

# Verify template file existence
if [ ! -f "${TELEGRAF_TEMPLATE_PATH}" ]; then
    echo "Error: Template file '${TELEGRAF_TEMPLATE_PATH}' not found!" >&2
    exit 1
fi

# Create target directories if missing
mkdir -p "${TMP_DIR}" "${RAW_METRICS_PATH}"

NOW=$(date '+%Y%m%d_%H%M%S')

echo "Writing updated Telegraf config to ${REAL_CONFIG_PATH}..."
# Stream replace placeholders directly to destination file
sed -e "s|<path_placeholder>|${RAW_METRICS_PATH}|g" \
    -e "s|<date_placeholder>|${NOW}|g" \
    "${TELEGRAF_TEMPLATE_PATH}" > "${REAL_CONFIG_PATH}"

echo "Starting Telegraf daemon..."
exec telegraf --config "${REAL_CONFIG_PATH}"