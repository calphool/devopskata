provider "aws" {
    access_key = ""
    secret_key = ""
    region = "ap-northeast-1"
}

resource "aws_instance" "jenkinsmaster" {
    ami = "ami-2ebd434f"
    instance_type = "t2.micro"
}
