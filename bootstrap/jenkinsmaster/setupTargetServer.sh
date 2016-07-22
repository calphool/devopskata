#!/bin/sh

sudo mkdir /perm  2> /dev/null
sudo mount /dev/xvdh /perm  2> /dev/null
sudo yum -y update
sudo yum -y install wget
sudo yum -y install git
sudo yum -y install java
java -version
cd ~
sudo rm -rf ~/devopskata 
sudo git clone https://github.com/calphool/devopskata.git
sudo yum -y install python
sudo yum -y install python-setuptools
sudo yum -y install gcc
sudo yum -y install python-devel
sudo yum -y install libffi-devel
sudo yum -y install openssl-devel
sudo yum -y install python-pip
sudo yum -y install nano
sudo pip install --upgrade pip
sudo pip install --upgrade setuptools
sudo pip install ansible
hash -r
sudo mkdir -p /etc/ansible
sudo echo 'localhost ansible_connection=local' | sudo tee --append /etc/ansible/hosts
sudo echo '[targetserver]' | sudo tee --append /etc/ansible/hosts
sudo echo 'localhost' | sudo tee --append /etc/ansible/hosts
sudo ansible buildserver -m ping
sudo sysctl -w net.ipv6.conf.all.disable_ipv6=1
sudo sysctl -w net.ipv6.conf.default.disable_ipv6=1
sudo ansible-galaxy install devops.tomcat7
sudo ansible-playbook /home/ec2-user/devopskata/bootstrap/targetserver/startTomcat.yml

#install hello page in tomcat
sudo mkdir -p /var/lib/tomcat/webapps/hello
cd /var/lib/tomcat/webapps
sudo chown root:tomcat hello
echo "Hello." > ~/index.html
sudo chown root:tomcat ~/index.html
sudo mv ~/index.html /var/lib/tomcat/webapps/hello
