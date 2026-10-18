#!/bin/bash

config=$(cat telegraf_template.conf)
now=$(date '+%Y%m%d_%H%M%S')
tmp_dir=../tmp
real_config_path="$tmp_dir/telegraf_config.conf"

modified_config=${config/"<date_placeholder>"/$now}

if [ ! -d "$tmp_dir" ]; then
  mkdir $tmp_dir
fi

echo "$modified_config" > $real_config_path

telegraf --config $real_config_path