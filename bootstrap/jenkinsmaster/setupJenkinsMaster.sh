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

sudo ./home/ec2-user/devopskata/bootstrap/shared/shared/setupAnsible.sh
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
sudo ./home/ec2-user/devopskata/bootstrap/shared/setupS3.sh jenkinsmaster
cd /home/ec2-user/s3;sudo cp -R -v . /var/lib/jenkins/
sudo chown -hRv jenkins:jenkins /var/lib/jenkins/jobs
sudo /etc/init.d/jenkins restart
sudo rm /home/ec2-user/p
