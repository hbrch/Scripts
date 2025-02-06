#!/bin/bash
# Created 27.06.2021
# Checking if the web server is still running, if not, then restarting it

# Define the service to monitor
SERVICE="apache2"

# Check if the service is running
if systemctl is-active --quiet "$SERVICE"; then
    echo "$SERVICE is running."
else
    echo "$SERVICE is not running. Restarting..."
    sudo systemctl restart "$SERVICE"
    echo "$SERVICE has been restarted."
fi
