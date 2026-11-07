CREATE SCHEMA IF NOT EXISTS bronze;
CREATE SCHEMA IF NOT EXISTS silver;
CREATE SCHEMA IF NOT EXISTS gold;


CREATE TABLE IF NOT EXISTS bronze.cpu_metrics
(
    timestamp BIGINT, -- raw unix epoch from Telegraf;
    measurement VARCHAR,
    cpu VARCHAR,
    host VARCHAR,
    usage_guest DOUBLE,
    usage_guest_nice DOUBLE,
    usage_idle DOUBLE,
    usage_iowait DOUBLE,
    usage_irq DOUBLE,
    usage_nice DOUBLE,
    usage_softirq DOUBLE,
    usage_steal DOUBLE,
    usage_system DOUBLE,
    usage_user DOUBLE,
    ingested_at TIMESTAMP,
    source_file VARCHAR
)