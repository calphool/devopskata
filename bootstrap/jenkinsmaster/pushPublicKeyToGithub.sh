#!/usr/bin/env bash

echo Code that pushes ./id_rsa.pub to $1, using $2:***** goes here...

passw=$(echo $3 | openssl enc -aes-128-cbc -a -d -salt -pass pass:wtf)

keydata=$(cat ./id_rsa.pub)
str1='{"title": "key-'
str1a=$str1$4"\", \"key\": "
str2=\"$keydata'", "read_only": true }'
str3=$str1a$str2
echo $str3 > tmp.txt
curl -H "Content-Type: application/json" -v -X POST -u $2:$passw https://api.github.com/repos/$2/$1/keys --data @tmp.txt
rm tmp.txt 2> /dev/null
