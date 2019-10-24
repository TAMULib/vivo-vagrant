#!/bin/bash

#
# Setup Tomcat
#

# Exit on first error
set -e

# Print shell commands
set -o verbose

export DEBIAN_FRONTEND=noninteractive

# Install Tomcat
installTomcat () {
  if [ ! -d "/opt/tomcat" ] ; then
    groupadd tomcat
    useradd -s /bin/false -g tomcat -d /opt/tomcat tomcat

    curl -O http://mirrors.sonic.net/apache/tomcat/tomcat-9/v9.0.27/bin/apache-tomcat-9.0.27.tar.gz

    mkdir /opt/tomcat
    tar xzvf apache-tomcat-9.0.27.tar.gz -C /opt/tomcat --strip-components=1

    cp /home/vagrant/provision/tomcat/tomcat.service /etc/systemd/system/tomcat.service

    chmod 0644 /etc/systemd/system/tomcat.service

    cp /home/vagrant/provision/tomcat/server.xml /opt/tomcat/conf/server.xml
    cp /home/vagrant/provision/tomcat/context.xml /opt/tomcat/webapps/manager/META-INF/context.xml
    cp /home/vagrant/provision/tomcat/context.xml /opt/tomcat/webapps/host-manager/META-INF/context.xml
    cp /home/vagrant/provision/tomcat/tomcat-users.xml /opt/tomcat/conf/tomcat-users.xml

    chgrp -R tomcat /opt/tomcat

    chmod -R g+r /opt/tomcat/conf
    chmod g+x /opt/tomcat/conf
    chown -R tomcat /opt/tomcat/webapps/ /opt/tomcat/work/ /opt/tomcat/temp/ /opt/tomcat/logs/

    systemctl daemon-reload

    systemctl start tomcat
    systemctl enable tomcat
  else
    systemctl restart tomcat
  fi
}

installTomcat

echo Tomcat installed.

exit

