#!/bin/bash

source variables.conf

cd $ARCHIVE_HOME/regal-api
$PLAY_HOME/play test
cd -