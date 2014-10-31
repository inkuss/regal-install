#! /bin/bash

if [ -f elasticsearch-1.1.0.deb ]
then
    echo "elasticsearch is already here! Stop downloading!"
else
    wget https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.1.0.deb
fi
echo "Install Elasticsearch"
echo "WARNING: if Elasticsearch is already installed the next command will"
echo "force to install 1.1.0"
echo "using sudo dpkg -i --force-confnew elasticsearch-1.1.0.deb"
echo "Please press cntrl+C to abort"
sudo dpkg -i --force-confnew elasticsearch-1.1.0.deb
echo "Start Elasticsearch"
sudo service elasticsearch start
