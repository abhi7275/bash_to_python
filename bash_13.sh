#!/bin/bash

CONFIG_FILE="/etc/app_configs/user_report.conf"

if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
    echo "Config file loaded"
else
    echo "Error: Config file not found. Exiting..."
    exit 1
fi

start_date=$1
end_date=$2

if [ -z "$start_date" ]; then
    start_date=$(date -d "yesterday" "+%Y-%m-%d 00:00:00")
    end_date=$(date "+%Y-%m-%d 00:00:00")
fi

logfile="$LOG_DIR/user_activity_$(date +%Y%m%d_%H%M%S).log"
exec 3>&1 1>> "$logfile" 2>&1

echo "Generating report from $start_date to $end_date..."

$HIVE_EXEC -f "$SCRIPT_DIR/user_activity_report.hql" \
    -hiveconf start_date="$start_date" \
    -hiveconf end_date="$end_date" \
    -hiveconf schema="$DB_NAME"

if [ $? -eq 0 ]; then
    echo "Report generated successfully" 1>&3
else
    echo "Report generation failed!" 1>&3
    exit 1
fi
