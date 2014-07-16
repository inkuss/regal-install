#! /bin/bash

source variables.conf

git clone https://github.com/jschnasse/regal-api.git $ARCHIVE_HOME/regal-api
git clone https://github.com/jschnasse/regal-import.git $ARCHIVE_HOME/regal-import

cd $ARCHIVE_HOME/regal-api
mvn clean install -DskipTests >> $ARCHIVE_HOME/logs/regal-build.log
cd -
cd $ARCHIVE_HOME/regal-import
mvn clean install -DskipTests >> $ARCHIVE_HOME/logs/regal-build.log
cd -
