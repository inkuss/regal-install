#! /bin/bash

password=$1
salt=`head /dev/urandom | tr -dc A-Za-z0-9 | head -c 13`
hash=`echo -n $salt$password | sha256sum | head -c 64`

echo $salt
echo $hash

