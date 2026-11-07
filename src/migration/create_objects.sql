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
    ingested_at TIMESTAMP DEFAULT now(),
    source_file VARCHAR
);

CREATE TABLE IF NOT EXISTS bronze.mem_metrics (
    timestamp BIGINT, -- raw unix epoch from Telegraf;
    measurement VARCHAR,
    host VARCHAR,
    active BIGINT,
    available BIGINT,
    available_percent DOUBLE,
    buffered BIGINT,
    cached BIGINT,
    commit_limit BIGINT,
    committed_as BIGINT,
    dirty BIGINT,
    free BIGINT,
    high_free BIGINT,
    high_total BIGINT,
    huge_page_size BIGINT,
    huge_pages_free BIGINT,
    huge_pages_total BIGINT,
    inactive BIGINT,
    low_free BIGINT,
    low_total BIGINT,
    mapped BIGINT,
    page_tables BIGINT,
    shared BIGINT,
    slab BIGINT,
    sreclaimable BIGINT,
    sunreclaim BIGINT,
    swap_cached BIGINT,
    swap_free BIGINT,
    swap_total BIGINT,
    total BIGINT,
    used BIGINT,
    used_percent DOUBLE,
    vmalloc_chunk BIGINT,
    vmalloc_total BIGINT,
    vmalloc_used BIGINT,
    write_back BIGINT,
    write_back_tmp BIGINT,
    ingested_at TIMESTAMP DEFAULT now(),
    source_file VARCHAR
);