#!/bin/bash

source variables.conf

cd $ARCHIVE_HOME/regal-api
$ARCHIVE_HOME/play-2.2.3/play test
status=$?
cat $ARCHIVE_HOME/fedora/server/logs/fedora.log
cd -

exit $status
