# OS Metrics
A simple project to learn dbt and DuckDB.

## Quick Start
This project is configured for Linux environments (Zorin OS / Ubuntu / Debian).

### Prerequisites
- Linux system with `sudo` access
- Standard utilities installed: `curl`, `unzip`

### Automatic Setup

Run the installation script to set up the environment:

```bash
chmod +x setup.sh
./setup.sh
```

Ensure your `.env` file is configured based on `.env.example`:
```bash
cp .env.example .env
```

---

## Running the Platform

Running the platform requires two separate processes in your terminal:

### Step 1: Start Source Data Generators (Terminal 1)
Generates initial dimension extracts and starts the Telegraf metric collection daemon in the foreground:

```bash
chmod +x start_sources.sh
./start_sources.sh
```

### Step 2: Start Dagster Orchestrator (Terminal 2)
In a new terminal window, parse the dbt manifest and launch the Dagster UI:

```bash
# Export environment variables & build manifest
set -o allexport && source .env && set +o allexport
uv run dbt parse

# Launch Dagster Dev Server
uv run dagster dev -f orchestration/definitions.py -d orchestration
```

Open your browser at `http://localhost:3000` to inspect the DAG, trigger runs, or enable automated schedules under the **Automation** tab.

---

## CLI Execution (Manual / CI)

If you need to run dbt transformations directly without the Dagster UI:

```bash
# Load environment variables
set -o allexport && source .env && set +o allexport

# Validate connection
uv run dbt debug --profiles-dir .

# Build all models and run assertions (Bronze -> Silver -> Gold)
uv run dbt build --profiles-dir .
```