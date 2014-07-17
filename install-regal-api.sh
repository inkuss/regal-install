#! /bin/bash

source variables.conf

git clone https://github.com/jschnasse/regal-api.git $ARCHIVE_HOME/regal-api
git clone https://github.com/jschnasse/regal-import.git $ARCHIVE_HOME/regal-import

cd $ARCHIVE_HOME/regal-api
git checkout $VERSION
mvn clean install -DskipTests >> $ARCHIVE_HOME/logs/regal-build.log
$ARCHIVE_HOME/play-2.2.3/play dist
cd -
git checkout $VERSION
cd $ARCHIVE_HOME/regal-import
mvn clean install -DskipTests >> $ARCHIVE_HOME/logs/regal-build.log
cd -

cd $ARCHIVE_HOME
unzip regal-api/target/universal/regal-api-*.*zip -d tmp
mv tmp/regal-api* regal-server
rmdir tmp
cd -