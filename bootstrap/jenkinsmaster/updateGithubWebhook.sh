#!/bin/bash


echo "external dns name: $1"
echo "repo name        : $2"
echo "github user      : $3"
echo "github pwd       : ********"
echo " "
cp githubWebhook.txt githubWebhook.bak
sed -i '' "s/EC2EXTERNALNAME/$(echo $1 | sed -e 's/\\/\\\\/g; s/\//\\\//g; s/&/\\\&/g')/g" githubWebhook.txt
curl -v -i -u "$3:$4" -X POST --data-binary @githubWebhook.txt https://api.github.com/repos/$3/$2/hooks
mv githubWebhook.bak githubWebhook.txt