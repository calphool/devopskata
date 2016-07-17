provider "aws" {
    region="ap-northeast-1"
}



resource "aws_security_group" "ssh_sg" {
  name = "ssh-sg"
  description = "Allow ssh and jenkins" 

  ingress {
      from_port = 22
      to_port = 22
      protocol = "TCP"
      cidr_blocks = ["INGRESSBLOCK"]
  }

  ingress {
      from_port = 8080
      to_port = 8080
      protocol = "TCP"
      cidr_blocks = ["INGRESSBLOCK","192.30.252.0/22"]
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
            "sudo git clone https://github.com/calphool/devopskata.git",
            "sudo ./devopskata/bootstrap/jenkinsmaster/provisionAnsible.sh",
            "sudo adduser chicken",
            "sudo passwd -d chicken",
            "sudo chage -d 0 chicken",
            "sudo usermod chicken -aG wheel",
            "sudo cp -r /home/ec2-user/* /home/chicken"
        ]
        connection {
            type = "ssh"
            user = "ec2-user"
            private_key="/Volumes/USBKEY/devops_1.pem"
        }

    }

}

resource "null_resource" "nlr" {
    provisioner "local-exec" {          
        command = "./updateGithubWebhook.sh ${aws_instance.jenkinsmaster.public_dns} GITHUB_REPONAME GITHUB_USER GITHUB_PWD"
    }
}
