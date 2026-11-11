#!/usr/bin/env bash
set -euo pipefail

echo "Loading environment variables from .env..."
set -o allexport && source .env && set +o allexport

echo "Generating dimension seeds..."
bash src/data_generators/generate_host.sh
bash src/data_generators/generate_component.sh

echo "Starting Telegraf daemon (Press Ctrl+C to gracefully stop)..."
# Using exec replaces the current shell process with Telegraf, 
# ensuring signals like Ctrl+C are handled properly by the daemon.
exec bash src/data_generators/generate_metric.sh