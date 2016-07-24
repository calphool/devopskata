#!/bin/sh

sudo mkdir /perm  2> /dev/null
sudo mount /dev/xvdh /perm  2> /dev/null
cat p | openssl enc -aes-128-cbc -a -d -salt -pass pass:wtf > q
chmod 600 p
chmod 600 q
sudo sysctl -w net.ipv6.conf.all.disable_ipv6=1
sudo sysctl -w net.ipv6.conf.default.disable_ipv6=1
sudo yum -y update
sudo yum -y install wget
sudo yum -y install git
sudo rm -rf ~/devopskata 
sudo git clone https://github.com/calphool/devopskata.git
sudo ./devopskata/bootstrap/jenkinsmaster/provisionAnsibleOnJenkinsMaster.sh
