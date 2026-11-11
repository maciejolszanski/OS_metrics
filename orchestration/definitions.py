import os
from pathlib import Path
from dagster import (
    Definitions, 
    ScheduleDefinition, 
    define_asset_job, 
    AssetSelection
)
from dagster_dbt import DbtCliResource

from orchestration.assets import dbt_os_metrics_assets

PROJECT_ROOT = Path(__file__).joinpath("..", "..").resolve()


all_dbt_assets_job = define_asset_job(
    name="OS_metrics",
    selection=AssetSelection.all()
)

dbt_5min_schedule = ScheduleDefinition(
    job=all_dbt_assets_job,
    cron_schedule="*/5 * * * *",
)

defs = Definitions(
    assets=[
        dbt_os_metrics_assets,
    ],
    jobs=[all_dbt_assets_job],
    schedules=[dbt_5min_schedule],
    resources={
        "dbt": DbtCliResource(project_dir=os.fspath(PROJECT_ROOT)),
    },
)