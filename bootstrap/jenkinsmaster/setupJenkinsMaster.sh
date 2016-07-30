#!/bin/sh

# $1 = s3 bucket name

/home/ec2-user/devopskata/bootstrap/shared/setupAnyServer.sh jenkinsmaster $1

# assure crudini is available
sudo yum -y install crudini

# update the repo settings to turn on optional (for xfvb)
sudo crudini --set /etc/yum.repos.d/redhat-rhui.repo rhui-REGION-rhel-server-optional enabled 1

# ruby tooling for watir
sudo yum -y install gcc ruby-devel rubygems

# assure cucumber is installed
sudo gem install --no-user-install cucumber

# assure selenium is installed
sudo gem install --no-user-install selenium

# make sure selenium install runs
/usr/local/bin/selenium install

# get headless gem
sudo gem install --no-user-install headless

# get watir-webdriver
sudo gem install --no-user-install watir-webdriver

# install xvfb
sudo yum install xorg-x11-server-Xvfb.x86_64 -y

# install firefox
sudo yum install firefox.x86_64 -y

# install imageMagick
sudo yum install ImageMagick.x86_64 -y

# install jenkins role
sudo ansible-galaxy install geerlingguy.jenkins

# run jenkins
sudo ansible-playbook /home/ec2-user/devopskata/bootstrap/jenkinsmaster/startJenkins.yml

# turn off requiretty (doesn't provide much security per various sources, and screws up jenkins)
echo 'Defaults:jenkins !requiretty' | sudo tee --append /etc/sudoers
echo 'jenkins ALL=(ALL) NOPASSWD: ALL' | sudo tee --append /etc/sudoers


# Pull data out of s3 for jenkins
sudo rsync -avm --exclude="**/builds/**" /home/ec2-user/s3/jenkins /var/lib

# make sure ownership is right for /var/lib/jenkins/jobs
sudo chown -hRv jenkins:jenkins /var/lib/jenkins

# restart jenkins
sudo /etc/init.d/jenkins restart

echo '----------------------------------------------------------------'
echo " Software customization complete for: jenkinsmaster             "
echo '----------------------------------------------------------------'

