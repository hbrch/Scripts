#!/bin/bash

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

# Execute the appropriate package manager update command
case "$DISTRO" in
    "Ubuntu"|"Debian")
        sudo apt update && sudo apt upgrade -y
        ;;
    "Fedora")
        sudo dnf update -y
        ;;
    "openSUSE")
        sudo zypper refresh && sudo zypper update -y
        ;;
    "Arch Linux")
        sudo pacman -Syu --noconfirm
        ;;
    *)
        echo "No supported package manager found."
        ;;
esac
