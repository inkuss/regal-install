#! /bin/bash

source variables.conf

if [ ! -d $ARCHIVE_HOME/regal-api ]
then
git clone https://github.com/edoweb/regal-api.git $ARCHIVE_HOME/regal-api 
fi
if [ ! -d $ARCHIVE_HOME/regal-import ]
then
git clone https://github.com/edoweb/regal-import.git $ARCHIVE_HOME/regal-import
fi

cd $ARCHIVE_HOME/regal-api
$ARCHIVE_HOME/activator-dist-1.3.5/activator clean
$ARCHIVE_HOME/activator-dist-1.3.5/activator dist
cd -

cd $ARCHIVE_HOME
kill `cat $ARCHIVE_HOME/regal-server/RUNNING_PID`
unzip regal-api/target/universal/regal-api-*zip -d tmp
mv regal-server $ARCHIVE_HOME/regal-server.`date  +"%Y%m%d%H%M"`
mv tmp/regal-api* regal-server
rm -rf tmp
cd -
