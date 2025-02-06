#!/bin/bash
# Created 09.05.2018

IDLE_TIME=300  # 5 minutes

while true; do
    IDLE=$(xprintidle)
    if [ "$IDLE" -gt $((IDLE_TIME * 1000)) ]; then
        echo "User inactive. Locking system..."
        gnome-screensaver-command -l
    fi
    sleep 10
done
