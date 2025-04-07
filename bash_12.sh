#!/bin/bash

CONFIG="/etc/project/data_ingestion.conf"

if [ ! -f "$CONFIG" ]; then
  echo "ERROR: Config file $CONFIG not found!"
  exit 1
else
  source "$CONFIG"
  echo "✔ Config loaded from $CONFIG"
fi

rundate=$1
start_date=$2
end_date=$3

if [ -z "$start_date" ]; then
  start_date=$(date -d "-1 day" "+%Y-%m-%d 00:00:00")
  end_date=$(date "+%Y-%m-%d 23:59:59")
fi

log_file="$LOG_DIR/data_ingestion_$rundate.log"
echo "Ingestion from $start_date to $end_date" | tee -a "$log_file"

$HIVE_BIN -f "$HQL_DIR/data_ingestion.hql" \
  -hiveconf db_name="$DB_NAME" \
  -hiveconf start_date="$start_date" \
  -hiveconf end_date="$end_date" >> "$log_file" 2>&1

if [ $? -eq 0 ]; then
  echo "✔ Data ingestion completed successfully" | tee -a "$log_file"
else
  echo "✖ Data ingestion failed" | tee -a "$log_file"
  exit 1
fi
