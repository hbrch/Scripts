#!/bin/bash

DIRS=("/var/log" "/tmp")
DAYS=7
LOGFILE="/var/log/cleanup.log"

echo "Starting file cleanup on $(date)" | tee -a $LOGFILE

for DIR in "${DIRS[@]}"; do
    find "$DIR" -type f -mtime +$DAYS -exec rm -f {} \;
    echo "Deleted files older than $DAYS days in $DIR" | tee -a $LOGFILE
done

echo "Cleanup completed." | tee -a $LOGFILE
