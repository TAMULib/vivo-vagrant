#!/bin/bash

#
# Setup Solr
#

# Exit on first error
set -e

# Print shell commands
set -o verbose

export DEBIAN_FRONTEND=noninteractive

# Install Solr 8.2.0
installSolr () {
  if [ ! -d "/opt/solr" ] ; then
    curl -O http://archive.apache.org/dist/lucene/solr/8.2.0/solr-8.2.0.tgz

    tar xzvf solr-8.2.0.tgz

    solr-8.2.0/bin/install_solr_service.sh ./solr-8.2.0.tgz

    git clone https://github.com/vivo-community/vivo-solr.git vivo-solr
    cp -R vivo-solr/vivocore /var/solr/data

    rm /var/solr/data/vivocore/conf/schema.xml

    chown -R solr:solr /var/solr

    systemctl restart solr
    systemctl enable solr
  else
    systemctl restart solr
  fi
}

installSolr

echo Solr installed.

exit

