#!/bin/bash
sudo dnf install epel-release -y
sudo dnf install memcached -y

# Start and enable Memcached
sudo systemctl start memcached
sudo systemctl enable memcached

# Configure Memcached to listen on all interfaces
sudo sed -i 's/127.0.0.1/0.0.0.0/g' /etc/sysconfig/memcached

# Restart Memcached to apply changes
sudo systemctl restart memcached

# Open firewall ports if firewalld is running
if command -v firewall-cmd >/dev/null 2>&1; then
  sudo firewall-cmd --add-port=11211/tcp --permanent
  sudo firewall-cmd --add-port=11111/udp --permanent
  sudo firewall-cmd --reload
else
  echo "firewalld not installed, skipping firewall configuration."
fi

# Check Memcached status
sudo systemctl status memcached