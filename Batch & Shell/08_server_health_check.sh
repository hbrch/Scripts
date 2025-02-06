#!/bin/bash
# Created 14.01.2025

# Define thresholds
CPU_THRESHOLD=80
MEMORY_THRESHOLD=90
DISK_THRESHOLD=90

# Get system metrics
CPU_LOAD=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
MEMORY_USAGE=$(free | grep Mem | awk '{print $3/$2 * 100.0}')
DISK_USAGE=$(df / | grep / | awk '{ print $5 }' | sed 's/%//g')

# Check if CPU load exceeds threshold
if (( $(echo "$CPU_LOAD > $CPU_THRESHOLD" | bc -l) )); then
    # Send desktop notification
    notify-send "CPU Load Alert" "Warning: CPU load is high at ${CPU_LOAD}%"
    # Send system alert to all users
    echo "Warning: CPU load is high at ${CPU_LOAD}%" | wall
fi

# Check if memory usage exceeds threshold
if (( $(echo "$MEMORY_USAGE > $MEMORY_THRESHOLD" | bc -l) )); then
    # Send desktop notification
    notify-send "Memory Usage Alert" "Warning: Memory usage is high at ${MEMORY_USAGE}%"
    # Send system alert to all users
    echo "Warning: Memory usage is high at ${MEMORY_USAGE}%" | wall
fi

# Check if disk usage exceeds threshold
if (( $DISK_USAGE > $DISK_THRESHOLD )); then
    # Send desktop notification
    notify-send "Disk Usage Alert" "Warning: Disk usage is high at ${DISK_USAGE}%"
    # Send system alert to all users
    echo "Warning: Disk usage is high at ${DISK_USAGE}%" | wall
fi

# Print current system status
echo "CPU Load: $CPU_LOAD%"
echo "Memory Usage: $MEMORY_USAGE%"
echo "Disk Usage: $DISK_USAGE%"
