#!/bin/sh

sudo mkdir -p /var/lib/jenkins/.ssh
sudo chmod 700 /var/lib/jenkins/.ssh
sudo chown jenkins:jenkins /var/lib/jenkins/.ssh
sudo mv /home/ec2-user/id_rsa /var/lib/jenkins/.ssh/id_rsa
sudo chmod 600 /var/lib/jenkins/.ssh/id_rsa
sudo chown jenkins:jenkins /var/lib/jenkins/.ssh/id_rsa