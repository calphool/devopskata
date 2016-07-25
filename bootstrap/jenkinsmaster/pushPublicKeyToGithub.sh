#!/usr/bin/env bash

echo Code that pushes ./id_rsa.pub to $1, using $2:***** goes here...

passw=$(echo $3 | openssl enc -aes-128-cbc -a -d -salt -pass pass:wtf)


# this rather incomprehensible line deletes any existing public keys from the project deploy keys list before we add the new one
# Basically the first part (before the first pipe) gets the list of keys in a json blob, then we invoke python to turn this 
# blob into a parsable DOM, then we.  The tr strips useless python characters off the result, and the last part
# iterates over the array, issuing deletes to github.... bash is a beautiful thing... /s

output=($(curl -s -H "Content-Type: application/json" -X GET -u $2:$passw https://api.github.com/repos/$2/$1/keys | python -c "import json,sys;obj=json.load(sys.stdin);print [str(o['url']) for o in obj]" | tr -d "[],'")); for fn in ${output[@]}; do curl -s -H "Content-Type: application/json" -X DELETE -u $2:$passw $fn; done;

# okay, now construct a new json blob and insert the new key

keydata=$(cat ./id_rsa.pub)
str1='{"title": "key-'
str1a=$str1$4"\", \"key\": "
str2=\"$keydata'", "read_only": true }'
str3=$str1a$str2
echo $str3 > tmp.txt
curl -H "Content-Type: application/json" -X POST -u $2:$passw https://api.github.com/repos/$2/$1/keys --data @tmp.txt
rm tmp.txt 2> /dev/null
