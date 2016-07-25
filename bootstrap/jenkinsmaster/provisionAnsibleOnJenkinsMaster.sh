#!/bin/bash

sudo yum -y install wget

# add EPEL to yum/rpm repos
sudo rpm -iUvh https://dl.fedoraproject.org/pub/epel/7/x86_64/e/$(wget --quiet -O - https://dl.fedoraproject.org/pub/epel/7/x86_64/e/ | grep -o '<a href=['"'"'"][^"'"'"']*['"'"'"]' | sed -e 's/^<a href=["'"'"']//' -e 's/["'"'"']$//' | sed -n -e '/^epel-release/p')


#go home
cd ~
sudo yum -y install python
sudo yum -y install python-setuptools
sudo yum -y install gcc
sudo yum -y install python-devel
sudo yum -y install libffi-devel
sudo yum -y install openssl-devel
sudo yum -y install python-pip
sudo yum -y install nano
sudo yum -y install ruby
gem install cucumber &
gem install selenium &
/usr/local/bin/selenium install
sudo pip install --upgrade pip
sudo pip install --upgrade setuptools
sudo pip install ansible
hash -r
sudo mkdir -p /etc/ansible
sudo echo 'localhost ansible_connection=local' | sudo tee --append /etc/ansible/hosts
sudo echo '[jenkinsmaster]' | sudo tee --append /etc/ansible/hosts
sudo echo 'localhost' | sudo tee --append /etc/ansible/hosts
sudo ansible jenkinsmaster -m ping
sudo ansible-galaxy install geerlingguy.jenkins
sudo tar zxf /perm/jenkins_state.tar.gz -C /
sudo ansible-playbook /home/ec2-user/devopskata/bootstrap/jenkinsmaster/startJenkins.yml
sudo /etc/init.d/jenkins restart
sudo ansible-galaxy install calphool.s3fs
sudo ansible-playbook /home/ec2-user/devopskata/bootstrap/jenkinsmaster/startS3fs.yml
echo 'user_allow_other' | sudo tee --append /etc/fuse.conf
sudo umount -f /home/ec2-user/s3 
sudo rm -rf /home/ec2-user/s3 
sudo mkdir -p /home/ec2-user/s3
sudo s3fs calphoolbucket /home/ec2-user/s3 -o passwd_file=/home/ec2-user/q -o allow_other
sleep 2
#sudo rm /home/ec2-user/q
#sudo rm /home/ec2-user/p
