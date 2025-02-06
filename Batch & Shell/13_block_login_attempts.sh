#!/bin/bash

# Variables
LOG_FILE="/var/log/auth.log"
THRESHOLD=5
BAN_COMMAND="iptables -A INPUT -s"

echo "Monitoring SSH login attempts..."

tail -Fn0 $LOG_FILE | while read LINE; do
    if echo "$LINE" | grep "Failed password" > /dev/null; then
        IP=$(echo $LINE | awk '{print $(NF-3)}')
        COUNT=$(grep "$IP" $LOG_FILE | grep "Failed password" | wc -l)
        
        if [ "$COUNT" -ge "$THRESHOLD" ]; then
            echo "Blocking IP: $IP due to excessive failed login attempts"
            $BAN_COMMAND $IP -j DROP
        fi
    fi
done
