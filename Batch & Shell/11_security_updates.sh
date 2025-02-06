#!/bin/bash
# Created 22.01.2021

# Check for available security updates
UPDATES=$(sudo apt-get update -q && sudo apt-get upgrade -s | grep -i "security" | wc -l)

# If there are security updates, install them
if [ "$UPDATES" -gt 0 ]; then
    echo "Installing security updates..."
    sudo apt-get update -y
    sudo apt-get upgrade -y
    echo "Security updates installed."
else
    echo "No security updates available."
fi
