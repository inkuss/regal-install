#!/bin/bash 

source variables.conf
export FEDORA_HOME=$ARCHIVE_HOME/fedora

sudo service elasticsearch restart

kill `ps -eaf|grep tomcat|awk '{print $2}'|head -1`


#cd $ARCHIVE_HOME/regal-api
#$ARCHIVE_HOME/play-2.2.3/play dist
#cd -

cd $ARCHIVE_HOME/regal-server
kill `cat RUNNING_PID`
nohup $ARCHIVE_HOME/regal-server/bin/regal-api &
cd -

$TOMCAT_HOME/bin/startup.sh

