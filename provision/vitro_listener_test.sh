#!/bin/bash

#
# Setup Vitro Listener Test
#

# Exit on first error
set -e

# Print shell commands
set -o verbose

export DEBIAN_FRONTEND=noninteractive

# Install Vitro Listener Test
installVitroListenerTest () {
  if [ ! -d "/home/vagrant/src/vitro-listener-test" ] ; then
    cd /home/vagrant/src

    git clone https://github.com/vivo-community/vitro-listener-test.git -b master

    ip="$(/sbin/ifconfig eth0 | grep 'inet' | head -1 | awk '{print $2}')"
    sed -i "s,tcp://localhost:61616,tcp://$ip:61616,g" /home/vagrant/src/vitro-listener-test/src/main/resources/application.yml

    cd vitro-listener-test
    mvn clean package
    cd ..

    chgrp -R tomcat /home/vagrant/src/vitro-listener-test

    cp /home/vagrant/provision/vitro-listener-test/vitro-listener-test.service /etc/systemd/system/vitro-listener-test.service

    chmod 0644 /etc/systemd/system/vitro-listener-test.service

    systemctl daemon-reload

    systemctl start vitro-listener-test
    systemctl status vitro-listener-test
    systemctl enable vitro-listener-test
  else
    systemctl restart vitro-listener-test
  fi
}

installVitroListenerTest

echo Vitro Listener Test installed.

exit
