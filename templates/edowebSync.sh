#! /bin/bash

source /home/cpt/local/opt/regal/sync/edowebVariables.conf
export LANG=en_US.UTF-8

cd $ARCHIVE_HOME/sync

cp .oaitimestamp$NAMESPACE oaitimestamp${NAMESPACE}`date +"%Y%m%d"`

java -jar -Xms512m -Xmx512m ${MODULE}sync.jar --mode PIDL -list $ARCHIVE_HOME/sync/pidlist.txt --user $USER --password $PASSWORD --dtl $DOWNLOAD --cache $ARCHIVE_HOME/${NAMESPACE}base --oai  $OAI --set $SET --timestamp .oaitimestamp$NAMESPACE --fedoraBase http://$SERVER:$TOMCAT_PORT/fedora --host http://$BACKEND --namespace $NAMESPACE >> edoweblog`date +"%Y%m%d"`.txt 2>&1

cd -
