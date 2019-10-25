#!/bin/bash

#
# Bootstrap
#

# Exit on first error
set -e

# Print shell commands
set -o verbose

export DEBIAN_FRONTEND=noninteractive

# Update Ubuntu packages. Comment out during development
apt-get update -y

# Install Maven
apt-get install -y maven

# Some utils
apt-get install -y git vim screen wget curl unzip

# Set time zone
timedatectl set-timezone America/New_York

# Setup Ubuntu Firewall
setupFirewall () {
  ufw allow 22
  ufw allow 1066
  ufw allow 8000
  ufw allow 8080
  ufw allow 8081
  ufw allow 8161
  ufw allow 8983
  ufw allow 61616
  ufw enable
}

setupSecurityLimits () {
  echo '*           soft    nofile           65000' >> /etc/security/limits.conf
  echo '*           hard    nproc           65000' >> /etc/security/limits.conf
}

setupFirewall

setupSecurityLimits

# ca-certificates-java must be explicitly installed as it is needed for maven based installation
/var/lib/dpkg/info/ca-certificates-java.postinst configure

# Make Karma scripts executable
chmod +x /home/vagrant/provision/karma.sh

echo Box boostrapped.

exit

