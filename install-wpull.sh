#!/bin/bash

# Folge https://wpull.readthedocs.io/en/master/install.html
sudo su
apt-get install python3.5
apt-get install python3-tornado
apt-get install python3-html5lib
apt-get install python3-chardet
apt-get install python3-sqlalchemy
apt-get install python3-psutil
apt-get install phantomjs
apt-get install youtube-dl
apt-get install python3-pip
pip3 install wpull
# Downloading/unpacking wpull
#  Downloading wpull-2.0.1.tar.gz (666kB): 666kB downloaded
type wpull
# wpull is hashed (/usr/local/bin/wpull)

