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
}
