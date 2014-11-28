#!/bin/bash

source variables.conf

function copyConfig()
{
cp $ARCHIVE_HOME/conf/tomcat-users.xml $TOMCAT_CONF
cp $ARCHIVE_HOME/conf/fedora-users.xml $ARCHIVE_HOME/fedora/server/config/
cp $ARCHIVE_HOME/conf/fedora.fcfg $ARCHIVE_HOME/fedora/server/config/
cp $ARCHIVE_HOME/conf/setenv.sh $TOMCAT_HOME/bin
cp $ARCHIVE_HOME/conf/application.conf $ARCHIVE_HOME/regal-server/conf
echo "Please execute the following commands manually"
echo "sudo cp $ARCHIVE_HOME/conf/elasticsearch.yml $ELASTICSEARCH_CONF"
echo "sudo cp $ARCHIVE_HOME/conf/regal-api /etc/init.d"
echo "sudo update-rc.d regal-api defaults 99 20"
echo "sudo cp $ARCHIVE_HOME/conf/tomcat6 /etc/init.d"
echo "sudo update-rc.d tomcat6 defaults 98 15"
}

copyConfig
