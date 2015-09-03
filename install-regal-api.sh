#! /bin/bash

source variables.conf

PORT=$1

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
unzip regal-api/target/universal/regal-api-*zip -d tmp
regalServerDir=regal-server.`date  +"%Y%m%d%H%M"`
mv tmp/regal-api* $regalServerDir
rm -rf tmp
sed s/"^http\.port=.*$"/"http\.port=\$PORT"/ regal-server/conf/application.conf > $regalServerDir/conf/application.conf
echo "New executable available under $regalServerDir. Provide port info at $regalServerDir/conf/application.conf."
cd -


