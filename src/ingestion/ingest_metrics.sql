SELECT host
FROM read_csv_auto('./data/raw/metrics*.csv',
    union_by_name = true,
    ignore_errors = true
);