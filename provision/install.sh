#!/bin/bash

#
# Install VIVO
#

# Exit on first error
set -e

# Print shell commands
set -o verbose

export DEBIAN_FRONTEND=noninteractive

# Make data directory
mkdir -p /opt/vivo
# Make config directory
mkdir -p /opt/vivo/config
# Make log directory
mkdir -p /opt/vivo/logs

# Make src directory
mkdir -p /home/vagrant/src

removeRDFFiles () {
  # In development, you might want to remove these ontology and data files
  # since they slow down Tomcat restarts considerably.
  rm /opt/vivo/rdf/tbox/filegraph/geo-political.owl
  rm /opt/vivo/rdf/abox/filegraph/continents.n3
  rm /opt/vivo/rdf/abox/filegraph/us-states.rdf
  rm /opt/vivo/rdf/abox/filegraph/geopolitical.abox.ver1.1-11-18-11.owl
  return $TRUE
}

setLogAlias () {
  # Alias for viewing VIVO log
  VLOG="alias vlog='less +F /opt/tomcat/logs/vivo.all.log'"
  BASHRC=/home/vagrant/.bashrc

  if grep "$VLOG" $BASHRC > /dev/null
  then
    echo "log alias exists"
  else
    (echo;  echo $VLOG)>> $BASHRC
    echo "log alias created"
  fi
}

setupTomcat () {
  cd ~
  # Change permissions
  dirs=( /opt/vivo /opt/tomcat/webapps/vivo )
  for dir in "${dirs[@]}"
  do
    chown -R vagrant:tomcat $dir
    chmod -R g+rws $dir
  done

  # Add redirect to /vivo in tomcat root
  rm -f /opt/tomcat/webapps/ROOT/index.html
  cp /home/vagrant/provision/vivo/index.jsp /opt/tomcat/webapps/ROOT/index.jsp
}

setupMySQL () {
  mysql --user=root --password=vivo -e "CREATE DATABASE vivo110dev CHARACTER SET utf8;" || true
  mysql --user=root --password=vivo -e "GRANT ALL ON vivo110dev.* TO 'vivo'@'localhost' IDENTIFIED BY 'vivo';"
}

installVIVO () {
  cd /home/vagrant/src

  if [ ! -d "/home/vagrant/src/Vitro" ] ; then
    git clone https://github.com/TAMULib/Vitro.git -b rdf-delta-messaging
  fi
  if [ ! -d "/home/vagrant/src/VIVO" ] ; then
    git clone https://github.com/vivo-project/VIVO.git -b rel-1.11.0-RC
  fi

  cd VIVO
  mvn clean install -DskipTests -s /home/vagrant/provision/vivo/settings.xml

  if [ ! -d "/opt/vivo/tdbContentModels" ] ; then
    cp -r /home/vagrant/vivo-data /opt/vivo/tdbContentModels
  fi

  cp /home/vagrant/provision/vivo/runtime.properties /opt/vivo/config/runtime.properties
  cp /home/vagrant/provision/vivo/developer.properties /opt/vivo/config/developer.properties
  cp /home/vagrant/provision/vivo/build.properties /opt/vivo/config/build.properties
  cp /home/vagrant/provision/vivo/applicationSetup.n3 /opt/vivo/config/applicationSetup.n3

  ip="$(/sbin/ifconfig eth0 | grep 'inet' | head -1 | awk '{print $2}')"
  sed -i "s,tcp://localhost:61616?type=TOPIC_CF,tcp://$ip:61616?type=TOPIC_CF,g" /opt/vivo/config/applicationSetup.n3

  chgrp -R tomcat /opt/vivo
  chown -R tomcat /opt/vivo
}

# Stop tomcat
systemctl stop tomcat

# add vagrant to tomcat group
if ! id "vagrant" >/dev/null 2>&1; then
  echo "Creating 'vagrant' user"
  adduser --disabled-password --gecos "" vagrant || true
fi
usermod -a -G tomcat vagrant || true

# create VIVO database
setupMySQL

# install the app
installVIVO

# Adjust tomcat permissions
setupTomcat

# Set a log alias
setLogAlias

# Stop tomcat
systemctl start tomcat

echo VIVO installed.

exit

