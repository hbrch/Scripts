#!/bin/bash

# Define log file
LOG_FILE="/var/log/system_monitor.log"

# Define interval (in seconds)
INTERVAL=60

# Define threshold limits
CPU_THRESHOLD=80
MEMORY_THRESHOLD=90
DISK_THRESHOLD=90

# Header for log file
echo "System Resource Monitoring Log - $(date)" > "$LOG_FILE"
echo "-----------------------------------------------------" >> "$LOG_FILE"

# Monitor every $INTERVAL seconds
while true; do
    CPU_LOAD=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
    MEMORY_USAGE=$(free | grep Mem | awk '{print $3/$2 * 100.0}')
    DISK_USAGE=$(df / | grep / | awk '{ print $5 }' | sed 's/%//g')

    # Log the resource usage
    echo "$(date) - CPU Load: $CPU_LOAD%, Memory Usage: $MEMORY_USAGE%, Disk Usage: $DISK_USAGE%" >> "$LOG_FILE"

    # Check thresholds and alert if needed
    if (( $(echo "$CPU_LOAD > $CPU_THRESHOLD" | bc -l) )); then
        echo "$(date) - Warning: CPU load is high at ${CPU_LOAD}%" >> "$LOG_FILE"
    fi

    if (( $(echo "$MEMORY_USAGE > $MEMORY_THRESHOLD" | bc -l) )); then
        echo "$(date) - Warning: Memory usage is high at ${MEMORY_USAGE}%" >> "$LOG_FILE"
    fi

    if (( $DISK_USAGE > $DISK_THRESHOLD )); then
        echo "$(date) - Warning: Disk usage is high at ${DISK_USAGE}%" >> "$LOG_FILE"
    fi

    # Wait before checking again
    sleep "$INTERVAL"
done
