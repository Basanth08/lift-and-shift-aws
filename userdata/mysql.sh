#!/bin/bash
DATABASE_PASS='admin123'

# Update and install required packages
sudo yum update -y
sudo yum install -y epel-release git zip unzip mariadb-server

# Start and enable MariaDB
sudo systemctl start mariadb
sudo systemctl enable mariadb

# Clone the project repo
cd /tmp/
if [ ! -d vprofile-project ]; then
  git clone -b main https://github.com/hkhcoder/vprofile-project.git
fi

# Set root password (only if not already set)
sudo mysqladmin -u root password "$DATABASE_PASS"

# Secure MariaDB installation (compatible with newer MariaDB)
sudo mysql -u root -p"$DATABASE_PASS" <<EOF
DELETE FROM mysql.user WHERE User='';
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
FLUSH PRIVILEGES;
EOF

# Create database and user if not exists
sudo mysql -u root -p"$DATABASE_PASS" <<EOF
CREATE DATABASE IF NOT EXISTS accounts;
GRANT ALL PRIVILEGES ON accounts.* TO 'admin'@'localhost' IDENTIFIED BY 'admin123';
GRANT ALL PRIVILEGES ON accounts.* TO 'admin'@'%' IDENTIFIED BY 'admin123';
FLUSH PRIVILEGES;
EOF

# Import the database backup if the file exists
if [ -f /tmp/vprofile-project/src/main/resources/db_backup.sql ]; then
  sudo mysql -u root -p"$DATABASE_PASS" accounts < /tmp/vprofile-project/src/main/resources/db_backup.sql
else
  echo "WARNING: db_backup.sql not found, skipping import."
fi

# Restart MariaDB
sudo systemctl restart mariadb

# (Optional) Firewalld section - skip if not installed
if command -v firewall-cmd >/dev/null 2>&1; then
  sudo systemctl start firewalld
  sudo systemctl enable firewalld
  sudo firewall-cmd --get-active-zones
  sudo firewall-cmd --zone=public --add-port=3306/tcp --permanent
  sudo firewall-cmd --reload
  sudo systemctl restart mariadb
else
  echo "firewalld not installed, skipping firewall configuration."
fi