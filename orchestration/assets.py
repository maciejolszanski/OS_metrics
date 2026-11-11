import subprocess
from pathlib import Path
from dagster import asset, AssetExecutionContext
from dagster_dbt import DbtCliResource, dbt_assets

# Path pointing to project root (where dbt project files live)
PROJECT_ROOT = Path(__file__).joinpath("..", "..").resolve()
MANIFEST_PATH = PROJECT_ROOT.joinpath("target", "manifest.json")

# 1. Automatic registration of all dbt models as Dagster Assets
@dbt_assets(manifest=MANIFEST_PATH)
def dbt_os_metrics_assets(context: AssetExecutionContext, dbt: DbtCliResource):
    yield from dbt.cli(["build"], context=context).stream()
