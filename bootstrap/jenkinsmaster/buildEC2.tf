provider "aws" {
    region="ap-northeast-1"
}



resource "aws_security_group" "ssh_sg" {
  name = "ssh-sg"
  description = "Allow ssh" 

  ingress {
      from_port = 22
      to_port = 22
      protocol = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
      from_port = 0
      to_port = 0
      protocol = -1
      cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_instance" "jenkinsmaster" {
    ami = "ami-2ebd434f"
    instance_type = "t2.micro"
    key_name="devops_1"
    tags {
        name = "JenkinsMaster"
    }
    connection {
        user="${connectionuser}"
        key_file="${connectionkeyfile}"
    }
    security_groups = ["${aws_security_group.ssh_sg.name}"]


    provisioner "remote-exec" {
        inline = [
            "sudo yum -y update",
            "sudo yum -y install wget",
            "sudo yum -y install git",
            "sudo yum -y install python-setuptools",
            "sudo git clone https://github.com/ansible/ansible.git",
            "sudo git clone https://github.com/calphool/devopskata.git",
            "sudo adduser chicken",
            "sudo passwd -d chicken",
            "sudo chage -d 0 chicken",
            "sudo usermod chicken -aG wheel",
            "sudo mv /home/ec2-user/* /home/chicken",
            "sudo userdel -r ec2-user"
        ]
        connection {
            type = "ssh"
            user = "ec2-user"
            private_key="/Volumes/USBKEY/devops_1.pem"
        }
    }
}

