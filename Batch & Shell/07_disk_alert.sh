#!/bin/bash
# Created 22.01.2019

# Threshold in percentage
THRESHOLD=80

# Check disk usage and extract the usage percentage of the root directory
DISK_USAGE=$(df / | grep / | awk '{ print $5 }' | sed 's/%//g')

# If disk usage exceeds threshold, send an alert
if [ $DISK_USAGE -gt $THRESHOLD ]; then
    echo "Warning: Disk usage is at ${DISK_USAGE}% which exceeds the threshold of ${THRESHOLD}%." 
fi

# Output current disk usage for logging
echo "Current disk usage: ${DISK_USAGE}%"
