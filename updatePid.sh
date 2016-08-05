#! /bin/bash

. variables.conf

pid=$1
server=$2
date=$3

echo "lobidify $pid"
curl -s -uedoweb-admin:$PASSWORD -XPOST $server/utils/updateMetadata/$pid?date=$date -H"accept: application/json" 
