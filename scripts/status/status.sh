#! /bin/bash

until=$1
ct=$2

from=0
step=10
user=edoweb-admin
pwd=01edo10web13
ns=edoweb
dir=$ct-`date +"%Y%m%d%H%M%S"`
mkdir $dir

function listRanges()
{
while [ $from -lt $until ]
do
echo $from , `expr $from + $step`;
from=$(($from+$step))
done
}

function getStatus()
{
user=$2
pwd=$3
ct=$4
ns=$5
dir=$6
IFS=', ' read -a array <<< "$1"
echo Process "${array[0]}"-"${array[1]}"-status.html 
curl -s -u$user:$pwd "edoweb-rlp.de:9000/resource/status?contentType=$ct&namespace=$ns&from=${array[0]}&until=${array[1]}" -H"accept: application/json" > $dir/${array[0]}-${array[1]}-status.json 
}

export -f getStatus
listRanges | parallel getStatus {} $user $pwd $ct $ns $dir

jq '.[]|.urnStatus, .pid, .links.frontend' $dir/*.json |awk '{getline b; getline c;printf("%s %s %s\n",$0,b,c)}'|sed s/" "/","/g |sed s/"\""/""/g |grep ^404 > $dir/urn-problems.txt

jq '.[]|.urnStatus, .pid, .links.frontend' $dir/*.json |awk '{getline b; getline c;printf("%s %s %s\n",$0,b,c)}'|sed s/" "/","/g |sed s/"\""/""/g |grep ^500 >> $dir/urn-problems.txt

