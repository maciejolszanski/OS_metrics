#!/usr/bin/env bash
set -e

# Load environment variables from .env if available
if [ -f .env ]; then
    set -o allexport
    source .env
    set +o allexport
fi

if [ -z "${RAW_DIMENSIONS_PATH}" ]; then
    echo "Error: RAW_DIMENSIONS_PATH environment variable is not set." >&2
    exit 1
fi

# Create target directory
mkdir -p "${RAW_DIMENSIONS_PATH}"

# Generate timestamped filename
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
OUTPUT_FILE="${RAW_DIMENSIONS_PATH}/host_${TIMESTAMP}.csv"

# Collect system metrics
HOST_NAME=$(hostname)
OS_NAME=$(hostnamectl | grep "Operating System" | cut -d':' -f2 | xargs)
KERNEL=$(uname -r)

# Write header and record to CSV
echo "timestamp,host,friendly_name,os_version,kernel" > "${OUTPUT_FILE}"
echo "${TIMESTAMP},${HOST_NAME},${HOST_NAME},${OS_NAME},${KERNEL}" >> "${OUTPUT_FILE}"

echo "Generated seed file: ${OUTPUT_FILE}"