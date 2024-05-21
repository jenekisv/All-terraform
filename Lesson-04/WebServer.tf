#----------------------------------------------------------
# My Terraform
#
# Build WebServer during Bootstrap
#
# Made by Evgenii Sviridov 2024
#----------------------------------------------------------


provider "aws" {
  region = "us-east-1"
}

resource "aws_default_vpc" "default" {} # This need to be added since AWS Provider v4.29+ to get VPC id

resource "aws_instance" "my_webserver" {
  ami                    = "ami-051f8a213df8bc089"
  instance_type          = "t2.micro"
  key_name               = "evgen-key-n_virginia" # ispolzovat secret key
  vpc_security_group_ids = [aws_security_group.my_webserver.id]
  user_data = templatefile("user_data.sh.tpl", {
    f_name = "Evgenii",
    l_name = "Sviridov",
    names  = ["Vasya", "Kolya", "Petya", "John", "Donald", "Masha"]
  })

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "optional"
  } # chtobi rabotali IMDSv1 "/meta-data/local-ipv4"

  tags = {
    Name  = "Web Server Build by Terraform"
    Owner = "Evgenii Sviridov"
  }
}


resource "aws_security_group" "my_webserver" {
  name        = "WebServer Security Group"
  description = "My First SecurityGroup"
  vpc_id      = aws_default_vpc.default.id # This need to be added since AWS Provider v4.29+ to set VPC id

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  } # otpravka tolko echo zaprosa

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = "Web Server SecurityGroup"
    Owner = "Evgenii Sviridov"
  }
}
