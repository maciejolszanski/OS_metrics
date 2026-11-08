#!/usr/bin/env bash
set -euo pipefail

# OS Verification
OS_TYPE="$(uname -s)"
case "${OS_TYPE}" in
    Linux*)
        ;;
    Darwin*)
        echo "Error: macOS is not supported. This script requires a Linux environment." >&2
        exit 1
        ;;
    CYGWIN*|MINGW*|MSYS*)
        echo "Error: Windows is not supported. This script requires a Linux environment." >&2
        exit 1
        ;;
    *)
        echo "Error: Unsupported OS (${OS_TYPE}). This script requires a Linux environment." >&2
        exit 1
        ;;
esac

echo "Initializing OS_metrics project..."

# 1. Require existing .env file
if [ ! -f ".env" ]; then
    echo "Error: .env file is missing!" >&2
    echo "Please copy .env.example to .env and configure your environment variables first:" >&2
    echo "  cp .env.example .env" >&2
    exit 1
fi

set -o allexport
source .env
set +o allexport

# Validate required variables
if [ -z "${RAW_METRICS_PATH:-}" ] || [ -z "${RAW_DIMENSIONS_PATH:-}" ] || [ -z "${DUCKDB_PATH:-}" ]; then
    echo "Error: Required path variables (RAW_METRICS_PATH, RAW_DIMENSIONS_PATH, DUCKDB_PATH) are missing in .env." >&2
    exit 1
fi

# 2. Create runtime directories from .env configuration
mkdir -p "$(dirname "${DUCKDB_PATH}")" "${RAW_METRICS_PATH}" "${RAW_DIMENSIONS_PATH}"

# 3. Install uv package manager (if missing)
if command -v uv &> /dev/null; then
    echo "uv package manager is already installed. Skipping..."
else
    echo "Downloading uv package manager..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
    source "$HOME/.local/bin/env" 2>/dev/null || export PATH="$HOME/.local/bin:$PATH"
fi

# 4. Sync dependencies from pyproject.toml
if [ -f "pyproject.toml" ]; then
    echo "Syncing Python dependencies..."
    uv sync
fi

# 5. Download DuckDB CLI binary locally
if [ -f "./duckdb" ]; then
    echo "DuckDB CLI binary already exists. Skipping..."
else
    echo "Downloading DuckDB CLI..."
    curl -L -o duckdb.zip https://github.com/duckdb/duckdb/releases/download/v1.1.3/duckdb_cli-linux-amd64.zip
    unzip -q -o duckdb.zip
    rm duckdb.zip
    chmod +x duckdb
fi

# 6. Install Telegraf (Zorin OS / Debian / Ubuntu)
if command -v telegraf &> /dev/null; then
    echo "Telegraf is already installed. Skipping..."
else
    echo "Installing Telegraf from official InfluxData repository..."
    sudo mkdir -p /etc/apt/keyrings
    curl -s https://repos.influxdata.com/influxdata-archive_compat.key | gpg --dearmor | sudo tee /etc/apt/keyrings/influxdata-archive.gpg > /dev/null
    echo 'deb [signed-by=/etc/apt/keyrings/influxdata-archive.gpg] https://repos.influxdata.com/debian stable main' | sudo tee /etc/apt/sources.list.d/influxdata.list
    sudo apt update && sudo apt install -y telegraf
fi

# 7. Initialize database file in DuckDB using DUCKDB_PATH
echo "Initializing DuckDB Database at ${DUCKDB_PATH}..."
./duckdb "${DUCKDB_PATH}" "SELECT 1;" > /dev/null

echo "Environment setup complete!"