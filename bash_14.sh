#!/bin/bash

CONFIG="/opt/app/conf/cleaner.conf"

if [ -f "$CONFIG" ]; then
    source "$CONFIG"
else
    echo "Missing config file. Exiting."
    exit 1
fi

log_dir=${LOG_DIR:-"/var/log/app"}
days_old=${DAYS_OLD:-30}

echo "Cleaning logs older than $days_old days from $log_dir"
find "$log_dir" -type f -name "*.log" -mtime +$days_old -exec rm -f {} \;

if [ $? -eq 0 ]; then
    echo "Cleanup complete."
else
    echo "Cleanup encountered errors."
    exit 1
fi
