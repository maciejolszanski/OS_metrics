SELECT 
    timestamp,
    host,
    component_id,
    component_name,
    component_type,
    capacity,
    now() as ingested_at,
    filename as source_file
FROM read_csv_auto(
    '{{ env_var("RAW_DIMENSIONS_PATH") }}/component_*.csv',
    union_by_name=true,
    filename=true
)