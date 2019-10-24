#!/bin/bash

#
# Setup MySQL
#

# Exit on first error
set -e

# Print shell commands
set -o verbose

export DEBIAN_FRONTEND=noninteractive

# Install MariaDB
installMySQL () {
  apt-get install -y mariadb-server mariadb-client
  mysqladmin -u root password vivo
}

installMySQL

echo MySQL installed.

exit

