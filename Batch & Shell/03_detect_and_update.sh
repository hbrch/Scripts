#!/bin/bash
# Created 07.01.2022
# Originally wrote for my Installation Setup

# Detect the distribution
if [ -f /etc/os-release ]; then
    # Modern systems
    . /etc/os-release
    DISTRO="$NAME"
elif [ -f /etc/lsb-release ]; then
    # Older Ubuntu/Debian systems
    . /etc/lsb-release
    DISTRO="$DISTRIB_ID"
elif [ -f /etc/debian_version ]; then
    DISTRO="Debian"
elif [ -f /etc/fedora-release ]; then
    DISTRO="Fedora"
elif [ -f /etc/os-release ] && grep -qi "opensuse" /etc/os-release; then
    DISTRO="openSUSE"
elif [ -f /etc/arch-release ]; then
    DISTRO="Arch Linux"
else
    DISTRO="Unknown"
fi

# Function to log update output
LOGFILE="/var/log/system_update.log"
echo "Starting system update on $(date)" | sudo tee -a $LOGFILE

# Function to check if the package manager exists
check_command() {
    command -v "$1" >/dev/null 2>&1
}

# Prompt user for confirmation
read -p "Do you want to proceed with the update? (y/N): " CONFIRM
if [[ "$CONFIRM" != "y" && "$CONFIRM" != "Y" ]]; then
    echo "Update canceled."
    exit 1
fi

# Execute the appropriate package manager update command
case "$DISTRO" in
    "Ubuntu"|"Debian")
        if check_command apt; then
            sudo apt update && sudo apt upgrade -y | sudo tee -a $LOGFILE
        else
            echo "APT package manager not found." | sudo tee -a $LOGFILE
        fi
        ;;
    "Fedora")
        if check_command dnf; then
            sudo dnf update -y | sudo tee -a $LOGFILE
        else
            echo "DNF package manager not found." | sudo tee -a $LOGFILE
        fi
        ;;
    "openSUSE")
        if check_command zypper; then
            sudo zypper refresh && sudo zypper update -y | sudo tee -a $LOGFILE
        else
            echo "Zypper package manager not found." | sudo tee -a $LOGFILE
        fi
        ;;
    "Arch Linux")
        if check_command pacman; then
            sudo pacman -Syu --noconfirm | sudo tee -a $LOGFILE
        else
            echo "Pacman package manager not found." | sudo tee -a $LOGFILE
        fi
        ;;
    *)
        echo "No supported package manager found." | sudo tee -a $LOGFILE
        ;;
esac

# Optional: Reboot if necessary
read -p "Reboot the system if kernel updates were installed? (y/N): " REBOOT
if [[ "$REBOOT" == "y" || "$REBOOT" == "Y" ]]; then
    sudo reboot
fi
