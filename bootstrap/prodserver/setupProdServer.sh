#!/bin/sh


# assure git is available
sudo yum -y install git

# assure ~/devopskata is gone
sudo rm -rf ~/devopskata 2> /dev/null

# clone devopskata.git for various scripts
sudo git clone https://github.com/calphool/devopskata.git

cd /home/ec2-user/devopskata/prodserver

# $1 = s3 bucket name
../shared/setupAnyServer.sh prodserver $1

echo 'Defaults !requiretty' | sudo tee --append /etc/sudoers
echo 'jenkins ALL=(ALL) NOPASSWD: ALL' | sudo tee --append /etc/sudoers

sudo yum -y install java-1.7.0-openjdk-devel.x86_64
java -version
cd ~

sudo ansible-galaxy install devops.tomcat7
sudo ansible-playbook /home/ec2-user/devopskata/bootstrap/prodserver/startTomcat.yml

#install hello page in tomcat
sudo mkdir -p /var/lib/tomcat/webapps/hello
cd /var/lib/tomcat/webapps
sudo chown root:tomcat hello
echo "Hello." > ~/index.html
sudo chown root:tomcat ~/index.html
sudo mv ~/index.html /var/lib/tomcat/webapps/hello

echo '----------------------------------------------------------------'
echo " Software customization complete for: prodserver                "
echo '----------------------------------------------------------------'
