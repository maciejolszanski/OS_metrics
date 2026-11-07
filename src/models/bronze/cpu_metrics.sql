SELECT 
    timestamp,
    measurement,
    cpu,
    host,
    usage_guest,
    usage_guest_nice,
    usage_idle,
    usage_iowait,
    usage_irq,
    usage_nice,
    usage_softirq,
    usage_steal,
    usage_system,
    usage_user,
    now() as ingested_at,
    filename as source_file
FROM read_csv_auto(
    './data/raw/cpu_*.csv',
    union_by_name=true,
    filename=true
)