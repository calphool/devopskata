#!/bin/sh

# turn off ipv6
sudo sysctl -w net.ipv6.conf.all.disable_ipv6=1
sudo sysctl -w net.ipv6.conf.default.disable_ipv6=1

# update yum
sudo yum -y update --exclude java-1.7.0-openjdk*

# make sure q is gone
sudo rm /home/ec2-user/.q 2> /dev/null

# decryption
cat p | openssl enc -aes-128-cbc -a -d -salt -pass pass:wtf > .q
chmod 600 p
chmod 600 .q

# cleanup
sudo rm /home/ec2-user/p

# make sure wget exists
sudo yum -y install wget

# assure /etc/ansible exists for role installation
sudo mkdir -p /etc/ansible

# put myself in /etc/ansible/hosts
echo 'localhost ansible_connection=local' | sudo tee --append /etc/ansible/hosts
echo "[$1]" | sudo tee --append /etc/ansible/hosts
echo 'localhost' | sudo tee --append /etc/ansible/hosts

# install ansible
sudo /home/ec2-user/devopskata/bootstrap/shared/setupAnsible.sh

# make sure I can ping myself (hey, that tickles)
sudo ansible $1 -m ping

# install s3fs file system (uses ansible)  $1=servername $2=s3 bucketname
sudo /home/ec2-user/devopskata/bootstrap/shared/setupS3.sh $1 $2

# assure git is available
sudo yum -y install git

# assure ~/devopskata is gone
sudo rm -rf ~/devopskata 2> /dev/null 

# clone devopskata.git for various scripts
sudo git clone https://github.com/calphool/devopskata.git


echo '----------------------------------------------------------------'
echo " Basic server setup complete for: $1 
echo '----------------------------------------------------------------'