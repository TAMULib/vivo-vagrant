#!/bin/bash

#
# Setup Artemis
#

# Exit on first error
set -e

# Print shell commands
set -o verbose

export DEBIAN_FRONTEND=noninteractive

# Install Artemis ActiveMQ
installArtemis () {
  if [ ! -d "/opt/artemis" ] ; then
    curl -O http://mirror.downloadvn.com/apache/activemq/activemq-artemis/2.10.1/apache-artemis-2.10.1-bin.tar.gz

    mkdir /opt/artemis
    tar xzvf apache-artemis-2.10.1-bin.tar.gz -C /opt/artemis --strip-components=1
  fi

  ip="$(/sbin/ifconfig eth0 | grep 'inet' | head -1 | awk '{print $2}')"
  /opt/artemis/bin/artemis create --name vitro-broker --host $ip --http-host $ip --user artemis --password artemis --allow-anonymous N /var/lib/vitro-broker

  /var/lib/vitro-broker/bin/artemis-service start
}

installArtemis

echo Artemis installed.

exit

