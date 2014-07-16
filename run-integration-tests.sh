#!/bin/bash

source variables.conf

cd $ARCHIVE_HOME/regal-api
/home/travis/opt/regal/play-2.2.3/play test
cd -