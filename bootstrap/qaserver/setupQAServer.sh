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

echo '----------------------------------------------------------------'
echo ' Software customization complete for: qaserver                  '
echo '----------------------------------------------------------------'
