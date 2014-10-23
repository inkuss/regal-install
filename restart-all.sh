#!/bin/bash 

source variables.conf
export FEDORA_HOME=$ARCHIVE_HOME/fedora

sudo service elasticsearch restart

cd $ARCHIVE_HOME/regal-server
if [ -f RUNNING_PID ]
then
kill `cat RUNNING_PID`
fi
nohup $ARCHIVE_HOME/regal-server/bin/regal-api &
cd -

kill `ps -eaf|grep tomcat|awk '{print $2}'|head -1`
sleep 10
$TOMCAT_HOME/bin/startup.sh
sleep 10

