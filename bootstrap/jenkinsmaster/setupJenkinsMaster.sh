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

#make sure jenkins directories are clean
sudo rm -rf /var/lib/jenkins/jobs 2> /dev/null
sudo rm -rf /var/lib/jenkins/config.xml 2> /dev/null

# install jenkins role
sudo ansible-galaxy install geerlingguy.jenkins

# turn off requiretty (doesn't provide much security per various sources, and screws up jenkins)
echo 'Defaults:jenkins !requiretty' | sudo tee --append /etc/sudoers
echo 'jenkins ALL=(ALL) NOPASSWD: ALL' | sudo tee --append /etc/sudoers

# run jenkins
sudo ansible-playbook /home/ec2-user/devopskata/bootstrap/jenkinsmaster/startJenkins.yml
sudo service jenkins stop

# Pull data out of s3 for jenkins
sudo rsync -avm --exclude="**/.ssh/**" --exclude="**/.gem/**" --exclude="**/builds/**" --exclude="**/workspace/**" /home/ec2-user/s3/jenkins/ /var/lib

# make sure ownership is right for /var/lib/jenkins/jobs
sudo chown -hRv jenkins:jenkins /var/lib/jenkins 2> /dev/null

# restart jenkins
sudo service jenkins start
sleep 20

a=$(cat /var/lib/jenkins/config.xml | grep 8081)

if [[ -z $a ]]; then
    echo '/var/lib/jenkins/config.xml does not appear to have port 8081 in it.  This will cause problems with slave instances.'
else
    echo '/var/lib/jenkins/config.xml appears to be okay'
fi

echo '----------------------------------------------------------------'
echo " Software customization complete for: jenkinsmaster             "
echo '----------------------------------------------------------------'
