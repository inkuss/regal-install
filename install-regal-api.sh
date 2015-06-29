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
mvn clean install -DskipTests >> $ARCHIVE_HOME/logs/regal-build.log
$ARCHIVE_HOME/play-2.2.3/play clean
$ARCHIVE_HOME/play-2.2.3/play dist
cd -

cd $ARCHIVE_HOME
kill `cat $ARCHIVE_HOME/regal-server/RUNNING_PID`
unzip regal-api/target/universal/regal-api-*zip -d tmp
mv regal-server $ARCHIVE_HOME/regal-server.`date  +"%Y%m%d%H%M"`
mv tmp/regal-api* regal-server
rm -rf tmp
cd -
