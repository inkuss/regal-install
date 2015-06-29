#! /bin/bash

source variables.conf

if [ -f heritrix-3.1.1-dist.zip ]
then
	echo "heritrix is already here! Stop downloading!"
else
	wget http://builds.archive.org/maven2/org/archive/heritrix/heritrix/3.1.1/heritrix-3.1.1-dist.zip
fi

unzip heritrix-3.1.1-dist.zip
mv heritrix-3.1.1 $ARCHIVE_HOME/
ln -s $ARCHIVE_HOME/heritrix-3.1.1 $ARCHIVE_HOME/heritrix


