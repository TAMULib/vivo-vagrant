#!/bin/bash

#
# Start Vitro Listener Test
#

# Exit on first error
set -e

# Print shell commands
set -o verbose

export DEBIAN_FRONTEND=noninteractive

# Start Vitro Listener Test
startVitroListenerTest () {
  if [ ! -d "/home/vagrant/src/vitro-listener-test" ] ; then
    cd /home/vagrant/src

    git clone https://github.com/vivo-community/vitro-listener-test.git -b master

    ip="$(/sbin/ifconfig eth0 | grep 'inet' | head -1 | awk '{print $2}')"
    sed -i "s,tcp://localhost:61616,tcp://$ip:61616,g" /home/vagrant/src/vitro-listener-test/src/main/resources/application.yml
  fi
  cd /home/vagrant/src/vitro-listener-test
    nohup mvn clean spring-boot:run &
  cd ~
}

startVitroListenerTest

echo Vitro Listener Test started.

exit
