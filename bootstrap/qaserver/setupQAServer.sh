#!/bin/sh

# $1 = s3 bucket server

/home/ec2-user/devopskata/bootstrap/shared/setupAnyServer.sh qaserver $1

echo 'Defaults !requiretty' | sudo tee --append /etc/sudoers
echo 'jenkins ALL=(ALL) NOPASSWD: ALL' | sudo tee --append /etc/sudoers

sudo yum -y install java-1.7.0-openjdk-devel.x86_64
java -version
cd ~

sudo ansible-galaxy install devops.tomcat7
sudo ansible-playbook /home/ec2-user/devopskata/bootstrap/qaserver/startTomcat.yml

#install hello page in tomcat
sudo mkdir -p /var/lib/tomcat/webapps/hello
cd /var/lib/tomcat/webapps
sudo chown root:tomcat hello
echo "Hello." > ~/index.html
sudo chown root:tomcat ~/index.html
sudo mv ~/index.html /var/lib/tomcat/webapps/hello

# set up mariadb client
echo '[mariadb]' | sudo tee /etc/yum.repos.d/MariaDB.repo
echo 'name = MariaDB' | sudo tee --append /etc/yum.repos.d/MariaDB.repo
echo 'baseurl = http://yum.mariadb.org/10.1/centos7-amd64' | sudo tee --append /etc/yum.repos.d/MariaDB.repo
echo 'gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB' | sudo tee --append /etc/yum.repos.d/MariaDB.repo
echo 'gpgcheck=1' | sudo tee --append /etc/yum.repos.d/MariaDB.repo

sudo yum install MariaDB-client -y

echo '----------------------------------------------------------------'
echo ' Software customization complete for: qaserver                  '
echo '----------------------------------------------------------------'
