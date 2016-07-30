sudo ansible-galaxy install calphool.s3fs
sudo ansible-playbook /home/ec2-user/devopskata/bootstrap/$1/startS3fs.yml
echo 'user_allow_other' | sudo tee --append /etc/fuse.conf
sudo umount -f /home/ec2-user/s3 2> /dev/null
sudo rm -rf /home/ec2-user/s3 
sudo mkdir -p /home/ec2-user/s3
sudo s3fs $2 /home/ec2-user/s3 -o passwd_file=/home/ec2-user/.q -o allow_other
sleep 2
