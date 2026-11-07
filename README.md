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

## 🏃 Running dbt Transformations

All dbt commands run inside the virtual environment managed by `uv`. The `--profiles-dir .` flag ensures dbt uses the repository's `profiles.yml`.

### 1. Test Connection
Verify the setup and DuckDB database connection:
```bash
uv run dbt debug --profiles-dir .
```

### 2. Run All Transformations
Build/refresh all models:
```bash
uv run dbt run --profiles-dir .
```