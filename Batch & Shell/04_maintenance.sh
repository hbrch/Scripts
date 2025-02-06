#!/bin/bash
# Created 19.07.2022

LOGFILE="/var/log/system_maintenance.log"

echo "Starting system maintenance on $(date)" | sudo tee -a $LOGFILE

# Detect the Linux distribution
if [ -f /etc/os-release ]; then
    . /etc/os-release
    DISTRO="$NAME"
elif [ -f /etc/lsb-release ]; then
    . /etc/lsb-release
    DISTRO="$DISTRIB_ID"
elif [ -f /etc/debian_version ]; then
    DISTRO="Debian"
elif [ -f /etc/fedora-release ]; then
    DISTRO="Fedora"
elif [ -f /etc/arch-release ]; then
    DISTRO="Arch Linux"
else
    DISTRO="Unknown"
fi

# Define package manager commands
update_system() {
    case "$DISTRO" in
        "Ubuntu"|"Debian")
            sudo apt update && sudo apt upgrade -y
            sudo apt autoremove -y && sudo apt clean
            ;;
        "Fedora")
            sudo dnf update -y
            sudo dnf autoremove -y
            ;;
        "openSUSE")
            sudo zypper refresh && sudo zypper update -y
            ;;
        "Arch Linux")
            sudo pacman -Syu --noconfirm
            sudo pacman -Sc --noconfirm
            ;;
        *)
            echo "No supported package manager found."
            ;;
    esac
}

# Check disk usage and clean logs if needed
clean_disk() {
    echo "Cleaning disk space..." | tee -a $LOGFILE
    sudo journalctl --vacuum-size=100M
    sudo rm -rf /var/tmp/*
}

# Check system health
check_system_health() {
    echo "Checking system health..." | tee -a $LOGFILE
    df -h | tee -a $LOGFILE
    free -h | tee -a $LOGFILE
    uptime | tee -a $LOGFILE
}

# Execute maintenance tasks
update_system | tee -a $LOGFILE
clean_disk | tee -a $LOGFILE
check_system_health | tee -a $LOGFILE

echo "System maintenance completed on $(date)" | sudo tee -a $LOGFILE
