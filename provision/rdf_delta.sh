#!/bin/bash

#
# Setup RDF Delta
#

# Exit on first error
set -e

# Print shell commands
set -o verbose

export DEBIAN_FRONTEND=noninteractive

# Install RDF Delta Server
installRDFDelta () {
  if [ ! -d "/opt/rdf-delta" ] ; then
    git clone https://github.com/afs/rdf-delta.git --depth 1 -b v0.7.0

    cd rdf-delta/rdf-delta-dist
    mvn clean package
    cd ../..

    unzip /home/vagrant/rdf-delta/rdf-delta-dist/target/rdf-delta-dist-0.7.0.zip -d /opt

    mv /opt/rdf-delta-0.7.0 /opt/rdf-delta

    mkdir /opt/vivo
    mkdir /opt/vivo/DeltaServer
    mkdir /opt/vivo/Zone

    cp /home/vagrant/provision/rdf-delta/delta-start.sh /opt/rdf-delta/delta-start.sh
    cp /home/vagrant/provision/rdf-delta/delta-stop.sh /opt/rdf-delta/delta-stop.sh

    chmod 0755 /opt/rdf-delta/delta-start.sh /opt/rdf-delta/delta-stop.sh

    chown -R tomcat:tomcat /opt/vivo/DeltaServer /opt/vivo/Zone /opt/rdf-delta
    chmod -R g+r /opt/vivo/DeltaServer /opt/vivo/Zone

    cp /home/vagrant/provision/rdf-delta/rdf-delta.service /etc/systemd/system/rdf-delta.service

    chmod 0644 /etc/systemd/system/rdf-delta.service

    systemctl daemon-reload

    systemctl start rdf-delta
    systemctl status rdf-delta
    systemctl enable rdf-delta
  else
    systemctl restart rdf-delta
  fi
}

installRDFDelta

echo RDF Delta installed.

exit

