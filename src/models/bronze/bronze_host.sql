{{
    config(
        alias='host'
    )
}}

SELECT 
    timestamp,
    host,
    friendly_name,
    os_version,
    kernel,
    now() as ingested_at,
    filename as source_file
FROM read_csv_auto(
    '{{ env_var("RAW_DIMENSIONS_PATH") }}/host_*.csv',
    union_by_name=true,
    filename=true
)

{% if is_incremental() %}
WHERE timestamp > (SELECT MAX(timestamp) FROM {{ this }})
{% endif %}