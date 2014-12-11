#! /bin/bash

source $ARCHIVE_HOME/sync/${NAMESPACE}Variables.conf

export LANG=en_US.UTF-8

cd $ARCHIVE_HOME/sync

cp .oaitimestamp${NAMESPACE} oaitimestamp${NAMESPACE}`date +"%Y%m%d"`

java -jar -Xms512m -Xmx512m ${MODULE}sync.jar --mode INIT -list $ARCHIVE_HOME/sync/pidlist.txt --user $REGAL_USER --password $REGAL_PASSWORD --dtl $DOWNLOAD --cache $ARCHIVE_HOME/${NAMESPACE}base --oai  $OAI --set $SET --timestamp .oaitimestamp${NAMESPACE} --fedoraBase http://$SERVER:$TOMCAT_PORT/fedora --host $BACKEND --namespace ${NAMESPACE} --keystoreLocation $keystoreLocation --keystorePassword $keystorePassword>> ${NAMESPACE}log`date +"%Y%m%d"`.txt 2>&1

cd -
