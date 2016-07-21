#!/bin/sh

sudo mkdir /perm
sudo mount /dev/xvdh /perm
sudo yum -y update
sudo yum -y install wget
sudo yum -y install git
sudo git clone https://github.com/calphool/devopskata.git
sudo ./devopskata/bootstrap/jenkinsmaster/provisionAnsibleOnJenkinsMaster.sh
