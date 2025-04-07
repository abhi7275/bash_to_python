#!/bin/bash

CONFIG_FILE="/data/conf/daily_etl.conf"
[ ! -f "$CONFIG_FILE" ] && echo "Missing config!" && exit 1

source "$CONFIG_FILE"

today=$(date "+%Y-%m-%d")
logfile="$LOG_DIR/daily_etl_$today.log"
exec 3>&1 1>> "$logfile" 2>&1

echo "Triggering ETL job for $today..."

$HIVE_EXEC -f "$SCRIPT_DIR/etl_job.hql" -hiveconf etl_date="$today"

if [ $? -eq 0 ]; then
    echo "ETL job completed successfully" 1>&3
else
    echo "ETL failed. Check logs." 1>&3
    exit 1
fi
