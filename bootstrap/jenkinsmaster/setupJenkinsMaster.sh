#!/bin/sh

sudo mkdir /perm
sudo mount /dev/xvdh /perm
sudo sysctl -w net.ipv6.conf.all.disable_ipv6=1
sudo sysctl -w net.ipv6.conf.default.disable_ipv6=1
sudo yum -y update
sudo yum -y install wget
sudo yum -y install git
sudo git clone https://github.com/calphool/devopskata.git
sudo ./devopskata/bootstrap/jenkinsmaster/provisionAnsibleOnJenkinsMaster.sh
