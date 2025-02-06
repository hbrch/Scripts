#!/bin/bash
# Created 09.05.2022

echo "Applying security hardening..."

# Update system
echo "Updating packages..."
apt update && apt upgrade -y

# Disable root login
echo "Disabling root login..."
sed -i 's/^PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
systemctl restart ssh

# Set up Uncomplicated Firewall (UFW)
echo "Configuring firewall..."
ufw allow OpenSSH
ufw enable
ufw status

# Ensure fail2ban is installed
echo "Setting up fail2ban..."
apt install fail2ban -y
systemctl enable fail2ban
systemctl start fail2ban

echo "Security hardening complete!"
