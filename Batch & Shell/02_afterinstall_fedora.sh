# Created 12.09.2022
# Adding RPMFusion, Flatpak and the Multimedia Codecs
# Also installs Firefox and Bitwarden
#!/bin/bash

if [[ $EUID -ne 0 ]]; then
  echo "You must be a root user to run this script, please run sudo ./install.sh" 2>&1
  exit 1
fi

#Update the system
dnf update -y

#RPMFusion
dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

#Flathub
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

#Multimedia Codecs
dnf install gstreamer1-plugins-{bad-*,good-*,base} gstreamer1-plugin-openh264 gstreamer1-libav --exclude=gstreamer1-plugins-bad-free-devel
dnf install lame* --exclude=lame-devel
dnf group upgrade --with-optional Multimedia

#Applications
dnf install firefox
flatpak install flathub com.bitwarden.desktop
