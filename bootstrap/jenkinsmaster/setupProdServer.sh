#!/bin/sh

sudo mkdir /perm  2> /dev/null
sudo mount /dev/xvdh /perm  2> /dev/null
sudo yum -y update
sudo yum -y install wget
sudo yum -y install git
sudo yum -y install java
java -version
sudo ./../shared/setupAnsible.sh
sudo mkdir -p /etc/ansible
sudo echo 'localhost ansible_connection=local' | sudo tee --append /etc/ansible/hosts
sudo echo '[prodserver]' | sudo tee --append /etc/ansible/hosts
sudo echo 'localhost' | sudo tee --append /etc/ansible/hosts
sudo ansible buildserver -m ping
sudo sysctl -w net.ipv6.conf.all.disable_ipv6=1
sudo sysctl -w net.ipv6.conf.default.disable_ipv6=1
sudo ansible-galaxy install devops.tomcat7
sudo ansible-playbook /home/ec2-user/devopskata/bootstrap/prodserver/startTomcat.yml

#install hello page in tomcat
sudo mkdir -p /var/lib/tomcat/webapps/hello
cd /var/lib/tomcat/webapps
sudo chown root:tomcat hello
echo "Hello." > ~/index.html
sudo chown root:tomcat ~/index.html
sudo mv ~/index.html /var/lib/tomcat/webapps/hello
cat p | openssl enc -aes-128-cbc -a -d -salt -pass pass:wtf > q
chmod 600 p
chmod 600 q
sudo ./../shared/setupS3.sh prodserver
sudo rm p