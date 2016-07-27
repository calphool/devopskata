#!/bin/sh

# make sure /perm is mounted
sudo mkdir /perm  2> /dev/null
sudo mount /dev/xvdh /perm  2> /dev/null

# decryption
cat p | openssl enc -aes-128-cbc -a -d -salt -pass pass:wtf > .q
chmod 600 p
chmod 600 .q

# turn off ipv6
sudo sysctl -w net.ipv6.conf.all.disable_ipv6=1
sudo sysctl -w net.ipv6.conf.default.disable_ipv6=1

# update yum
sudo yum -y update

# assure wget is available
sudo yum -y install wget

# assure git is available
sudo yum -y install git

# assure crudini is available
sudo yum -y install crudini

# assure ~/devopskata is gone
sudo rm -rf ~/devopskata 

# clone devopskata.git for various scripts
sudo git clone https://github.com/calphool/devopskata.git

# install ansible
sudo /home/ec2-user/devopskata/bootstrap/shared/setupAnsible.sh

# assure cucumber is installed
gem install cucumber &

# assure selenium is installed
gem install selenium 

# make sure selenium install runs
/usr/local/bin/selenium install &

# get headless gem
gem install headless &

# get watir-webdriver
gem install watir-webdriver &

# update the repo settings to turn on optional (for xfvb)
sudo crudini --set /etc/yum.repos.d/redhat-rhui.repo rhui-REGION-rhel-server-optional enabled 1

# install xvfb
sudo yum install xorg-x11-server-Xvfb.x86_64 -y &

# install firefox
sudo yum install firefox.x86_64 -y &

# install imageMagick
sudo yum install ImageMagick.x86_64 -y &

# assure /etc/ansible exists for role installation
sudo mkdir -p /etc/ansible

# put myself in /etc/ansible/hosts
echo 'localhost ansible_connection=local' | sudo tee --append /etc/ansible/hosts
echo '[jenkinsmaster]' | sudo tee --append /etc/ansible/hosts
echo 'localhost' | sudo tee --append /etc/ansible/hosts

# make sure I can ping myself (hey, that tickles)
sudo ansible jenkinsmaster -m ping

# install jenkins role
sudo ansible-galaxy install geerlingguy.jenkins

# untar saved jenkins state (plugins, jobs, configurations, etc.)
sudo tar zxf /perm/jenkins_state.tar.gz -C /var/lib/jenkins

# make sure jobs that were created when jenkins was first built are gone (can probably get rid of this now)
sudo rm -rf /var/lib/jenkins/jobs/devopskata_ci_project 2> /dev/null
sudo rm -rf /var/lib/jenkins/jobs/JenkinsTestProject 2> /dev/null

# run jenkins
sudo ansible-playbook /home/ec2-user/devopskata/bootstrap/jenkinsmaster/startJenkins.yml

# turn off requiretty (doesn't provide much security per various sources, and screws up jenkins)
echo 'Defaults:jenkins !requiretty' | sudo tee --append /etc/sudoers
echo 'jenkins ALL=(ALL) NOPASSWD: ALL' | sudo tee --append /etc/sudoers

# install s3fs file system (uses ansible)
sudo /home/ec2-user/devopskata/bootstrap/shared/setupS3.sh jenkinsmaster

# copy contents of s3 share to /var/lib/jenkins/jobs
cd /home/ec2-user/s3/jobs;sudo cp -R -v . /var/lib/jenkins/jobs/

# make sure ownership is right for /var/lib/jenkins/jobs
sudo chown -hRv jenkins:jenkins /var/lib/jenkins/jobs

# restart jenkins
sudo /etc/init.d/jenkins restart

# cleanup
sudo rm /home/ec2-user/p
