#!/bin/bash

config=$(cat telegraf_template.conf)
now=$(date '+%Y%m%d_%H%M%S')
tmp_dir=./tmp
raw_data_dir=./data/raw
real_config_path="$tmp_dir/telegraf_config.conf"

updated_config=${config/"<path_placeholder>"/$raw_data_dir}
final_config=${updated_config/"<date_placeholder>"/$now}

if [ ! -d "$tmp_dir" ]; then
  echo "Creating $tmp_dir directory"
  mkdir $tmp_dir
fi

if [ ! -d "$raw_data_dir" ]; then
  echo "Creating $raw_data_dir directory"
  mkdir $raw_data_dir
fi

echo "Writing updated config file to $tmp_dir"
echo "$final_config" > $real_config_path

echo "Starting telegraf deamon"
telegraf --config $real_config_path