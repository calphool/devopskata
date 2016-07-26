#!/bin/bash

sudo yum -y install wget

# add EPEL to yum/rpm repos
sudo rpm -iUvh https://dl.fedoraproject.org/pub/epel/7/x86_64/e/$(wget --quiet -O - https://dl.fedoraproject.org/pub/epel/7/x86_64/e/ | grep -o '<a href=['"'"'"][^"'"'"']*['"'"'"]' | sed -e 's/^<a href=["'"'"']//' -e 's/["'"'"']$//' | sed -n -e '/^epel-release/p')


#go home

sudo ./../shared/setupAnsible.sh
gem install cucumber &
gem install selenium &
/usr/local/bin/selenium install

sudo mkdir -p /etc/ansible
echo 'localhost ansible_connection=local' | sudo tee --append /etc/ansible/hosts
echo '[jenkinsmaster]' | sudo tee --append /etc/ansible/hosts
echo 'localhost' | sudo tee --append /etc/ansible/hosts
sudo ansible jenkinsmaster -m ping

sudo ansible-galaxy install geerlingguy.jenkins
sudo tar zxf /perm/jenkins_state.tar.gz -C /
sudo rm -rf /var/lib/jenkins/jobs/devopskata_ci_project
sudo rm -rf /var/lib/jenkins/jobs/JenkinsTestProject
sudo ansible-playbook /home/ec2-user/devopskata/bootstrap/jenkinsmaster/startJenkins.yml
echo 'Defaults:jenkins !requiretty' | sudo tee --append /etc/sudoers
echo 'jenkins ALL=(ALL) NOPASSWD: ALL' | sudo tee --append /etc/sudoers
./../shared/setupS3.sh jenkinsmaster
cd /home/ec2-user/s3;sudo cp -R -v . /var/lib/jenkins/
sudo chown -hRv jenkins:jenkins /var/lib/jenkins/jobs
sudo /etc/init.d/jenkins restart
#sudo rm /home/ec2-user/q
sudo rm /home/ec2-user/p
