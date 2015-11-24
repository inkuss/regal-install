#! /bin/bash

. variables.conf

pid=$1
server=$2

echo "lobidify"
curl -s -uedoweb-admin:$PASSWORD -XPOST $server/utils/lobidify/$pid -H"accept: application/json" 
echo "enrich"
curl -s -uedoweb-admin:$PASSWORD -XPOST $server/resource/$pid/metadata/enrich -H"accept: application/json" 
