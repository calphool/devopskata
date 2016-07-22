#!/bin/sh

sudo mkdir /perm 2> /dev/null
sudo mount /dev/xvdh /perm 2> /dev/null
sudo yum -y update
sudo yum -y install wget
sudo yum -y install git
sudo wget http://repos.fedorapeople.org/repos/dchen/apache-maven/epel-apache-maven.repo -O /etc/yum.repos.d/epel-apache-maven.repo
sudo sed -i s/\$releasever/6/g /etc/yum.repos.d/epel-apache-maven.repo
sudo yum install -y apache-maven
sudo yum -y install java
sudo yum -y install java-1.8.0-openjdk-devel.x86_64
mvn --version
java -version
javac -version
cd ~
rm -rf ~/devopskata 2> /dev/null
sudo git clone https://github.com/calphool/devopskata.git
sudo sysctl -w net.ipv6.conf.all.disable_ipv6=1
sudo sysctl -w net.ipv6.conf.default.disable_ipv6=1
