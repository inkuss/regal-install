#! /bin/bash

export HERITRIX_HOME=$ARCHIVE_HOME/heritrix

./bin/heritrix -aadmin:$PASSWORD -p 8443 -b / --ssl-params $ARCHIVE_HOME/conf/regal_keystore,'$PASSWORD'123,'$PASSWORD'123 --jobs-dir $ARCHIVE_HOME/heritrix-data/
