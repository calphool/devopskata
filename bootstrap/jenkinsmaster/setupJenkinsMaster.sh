#!/bin/sh

sudo yum -y update
sudo yum -y install wget
sudo yum -y install git
sudo git clone https://github.com/calphool/devopskata.git
sudo ./devopskata/bootstrap/jenkinsmaster/provisionAnsibleOnJenkinsMaster.sh
