#!/bin/bash

# Add swap space to prevent OOM errors (optional but recommended for t2.micro)
if ! swapon --show | grep -q '/swapfile'; then
  sudo dd if=/dev/zero of=/swapfile bs=1M count=1024
  sudo mkswap /swapfile
  sudo chmod 600 /swapfile
  sudo swapon /swapfile
fi

# Install EPEL and update system
sudo dnf install -y epel-release wget

# Install RabbitMQ (for Amazon Linux 2023, RHEL 9, etc.)
sudo dnf -y install centos-release-rabbitmq-38
sudo dnf --enablerepo=centos-rabbitmq-38 -y install rabbitmq-server

# Start and enable RabbitMQ
sudo systemctl start rabbitmq-server
sudo systemctl enable rabbitmq-server

# Open firewall port if firewalld is running
if command -v firewall-cmd >/dev/null 2>&1; then
  sudo firewall-cmd --add-port=5672/tcp --permanent
  sudo firewall-cmd --reload
else
  echo "firewalld not installed, skipping firewall configuration."
fi

# Allow remote connections
echo "[{rabbit, [{loopback_users, []}]}]." | sudo tee /etc/rabbitmq/rabbitmq.config

# Add test user and set as administrator
sudo rabbitmqctl add_user test test
sudo rabbitmqctl set_user_tags test administrator

# Restart RabbitMQ to apply config
sudo systemctl restart rabbitmq-server

# Show status
sudo systemctl status rabbitmq-server