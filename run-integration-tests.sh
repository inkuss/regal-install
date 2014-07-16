#!/bin/bash

source variables.conf

cd $ARCHIVE_HOME/regal-api
mvn clean test
cd -