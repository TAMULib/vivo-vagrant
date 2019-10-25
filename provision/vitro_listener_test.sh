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
  if [ ! -d "/opt/vitro-listener-test" ] ; then

    git clone https://github.com/vivo-community/vitro-listener-test.git -b master

    ip="$(/sbin/ifconfig eth0 | grep 'inet' | head -1 | awk '{print $2}')"
    sed -i "s,tcp://localhost:61616,tcp://$ip:61616,g" /home/vagrant/src/vitro-listener-test/src/main/resources/application.yml

    cd vitro-listener-test
    mvn clean package
    cd ..

    mv /home/vagrant/src/vitro-listener-test/target /opt/vitro-listener-test

    cp /home/vagrant/provision/vitro-listener-test/vlt-start.sh /opt/vitro-listener-test/vlt-start.sh
    cp /home/vagrant/provision/vitro-listener-test/vlt-stop.sh /opt/vitro-listener-test/vlt-stop.sh

    chgrp -R tomcat /opt/vitro-listener-test

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
