#!/usr/bin/env bash
set -e

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

# 1. Create runtime data directory
mkdir -p ./data

# 2. Install uv package manager (if missing)
if command -v uv &> /dev/null; then
    echo "uv package manager is already installed. Skipping..."
else
    echo "Downloading uv package manager..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
    source "$HOME/.local/bin/env" 2>/dev/null || export PATH="$HOME/.local/bin:$PATH"
fi

# 3. Sync dependencies from pyproject.toml
if [ -f "pyproject.toml" ]; then
    echo "Syncing Python dependencies..."
    uv sync
fi

# 4. Download DuckDB CLI binary locally
if [ -f "./duckdb" ]; then
    echo "DuckDB CLI binary already exists. Skipping..."
else
    echo "Downloading DuckDB CLI..."
    curl -L -o duckdb.zip https://github.com/duckdb/duckdb/releases/download/v1.1.3/duckdb_cli-linux-amd64.zip
    unzip -q -o duckdb.zip
    rm duckdb.zip
    chmod +x duckdb
fi

# 5. Install Telegraf (Zorin OS / Debian / Ubuntu)
if command -v telegraf &> /dev/null; then
    echo "Telegraf is already installed. Skipping..."
else
    echo "Installing Telegraf from official InfluxData repository..."
    curl -s https://repos.influxdata.com/influxdata-archive_compat.key | sudo apt-key add -
    echo 'deb https://repos.influxdata.com/debian stable main' | sudo tee /etc/apt/sources.list.d/influxdata.list
    sudo apt update && sudo apt install -y telegraf
fi

# 6. Initialize database file in DuckDB
echo "Initializing DuckDB Database..."
./duckdb ./data/os_metrics.duckdb "SELECT 1;" > /dev/null

echo "Environment setup complete!"