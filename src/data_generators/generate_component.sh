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
OUTPUT_FILE="${RAW_DIMENSIONS_PATH}/component_${TIMESTAMP}.csv"
HOSTNAME=$(hostname)

# Collect system component specs
CPU_MODEL=$(lscpu | grep "Model name:" | sed 's/Model name:\s*//' | xargs)
CPU_CORES=$(nproc)
TOTAL_RAM_GB=$(free -g | awk '/^Mem:/{print $2}')
DISK_SIZE_GB=$(lsblk -b -d -o SIZE,TYPE 2>/dev/null | awk '$2=="disk"{sum+=$1} END{print int(sum/1024/1024/1024)}')

# Write header and component records to CSV
echo "timestamp,host,component_id,component_name,component_type,capacity" > "${OUTPUT_FILE}"
echo "${TIMESTAMP},${HOSTNAME},cpu_main,\"${CPU_MODEL}\",CPU,${CPU_CORES} cores" >> "${OUTPUT_FILE}"
echo "${TIMESTAMP},${HOSTNAME},ram_main,System RAM,RAM,${TOTAL_RAM_GB} GB" >> "${OUTPUT_FILE}"
echo "${TIMESTAMP},${HOSTNAME},disk_main,Main Storage,DISK,${DISK_SIZE_GB} GB" >> "${OUTPUT_FILE}"

echo "Generated seed file: ${OUTPUT_FILE}"