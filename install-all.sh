#! /bin/bash
#
# Author: Jan Schnasse
# schnasse@hbz-nrw.de

source variables.conf

function install()
{
#echo "Install Elasticsearch"
#./install-elasticsearch.sh
echo "Install Fedora"
./install-fedora.sh
echo "Install Heritrix"
./install-heritrix.sh
echo "Install Play2"
./install-play.sh > /dev/null 
echo "Install Regal API"
./install-regal-api.sh
}

install

