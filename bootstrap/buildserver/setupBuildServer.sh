#!/bin/sh


# assure git is available
sudo yum -y install git

# assure ~/devopskata is gone
sudo rm -rf ~/devopskata 2> /dev/null

# clone devopskata.git for various scripts
sudo git clone https://github.com/calphool/devopskata.git

cd /home/ec2-user/devopskata/buildserver

# $1=bucketname
/home/ec2-user/devopskata/bootstrap/shared/setupAnyServer.sh buildserver $1

echo 'Defaults !requiretty' | sudo tee --append /etc/sudoers
echo 'jenkins ALL=(ALL) NOPASSWD: ALL' | sudo tee --append /etc/sudoers

sudo wget http://repos.fedorapeople.org/repos/dchen/apache-maven/epel-apache-maven.repo -O /etc/yum.repos.d/epel-apache-maven.repo
sudo sed -i s/\$releasever/6/g /etc/yum.repos.d/epel-apache-maven.repo
sudo yum -y install apache-maven
sudo yum -y install java
sudo yum -y install java-1.7.0-openjdk-devel.x86_64
mvn --version
java -version
javac -version
cd ~

echo '----------------------------------------------------------------'
echo " Software customization complete for: buildserver               "
echo '----------------------------------------------------------------'
