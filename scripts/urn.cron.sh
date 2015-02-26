#! /bin/bash

source functions.sh

date=`date --date="7 days ago" "+%Y-%m-%d"`

curl -s -XPOST -uedoweb-admin:nopwd "$BACKEND/utils/addUrnToAll?namespace=edoweb&snid=hbz:929:02&dateBefore=$date"
