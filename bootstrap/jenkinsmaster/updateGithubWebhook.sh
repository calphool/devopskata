#!/bin/bash


echo "external dns name: $1"
echo "repo name        : $2"
echo "github user      : $3"
echo "github pwd       : ********"
echo " "

passw=$(echo $4 | openssl enc -aes-128-cbc -a -d -salt -pass pass:wtf)

./removeWebhooks.sh $3 $passw $2

cp githubWebhook.template githubWebhook.txt
sed -i '' "s/EC2EXTERNALNAME/$(echo $1 | sed -e 's/\\/\\\\/g; s/\//\\\//g; s/&/\\\&/g')/g" githubWebhook.txt
curl -i -u "$3:$passw" -X POST --data-binary @githubWebhook.txt https://api.github.com/repos/$3/$2/hooks
rm githubWebhook.txt
