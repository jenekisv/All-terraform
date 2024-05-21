#----------------------------------------------------------
# My Terraform
#
# Made by Evgenii Sviridov 2024
#----------------------------------------------------------

provider "aws" {
  region = "us-east-1"
}

resource "aws_default_vpc" "default" {}

resource "aws_instance" "my_server_web" {
  ami                    = "ami-051f8a213df8bc089"
  instance_type          = "t2.micro"
  key_name               = "evgen-key-n_virginia"
  vpc_security_group_ids = [aws_security_group.my_webserver.id]

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "optional"
  }

  tags = {
    Name  = "Server-Web"
    Owner = "Evgenii Sviridov"
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [aws_instance.my_server_db, aws_instance.my_server_app]
}

resource "aws_instance" "my_server_app" {
  ami                    = "ami-051f8a213df8bc089"
  instance_type          = "t2.micro"
  key_name               = "evgen-key-n_virginia"
  vpc_security_group_ids = [aws_security_group.my_webserver.id]

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "optional"
  } # chtobi rabotali IMDSv1 "/meta-data/local-ipv4"

  tags = {
    Name  = "Server-Application"
    Owner = "Evgenii Sviridov"
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [aws_instance.my_server_db]
}


resource "aws_instance" "my_server_db" {
  ami                    = "ami-051f8a213df8bc089"
  instance_type          = "t2.micro"
  key_name               = "evgen-key-n_virginia" # ispolzovat secret key
  vpc_security_group_ids = [aws_security_group.my_webserver.id]

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "optional"
  } # chtobi rabotali IMDSv1 "/meta-data/local-ipv4"

  tags = {
    Name  = "Server-Database"
    Owner = "Evgenii Sviridov"
  }

  lifecycle {
    create_before_destroy = true
  }

}

resource "aws_security_group" "my_webserver" {
  name        = "My Security Group"
  description = "My First SecurityGroup"
  vpc_id      = aws_default_vpc.default.id # This need to be added since AWS Provider v4.29+ to set VPC id

  dynamic "ingress" {
    for_each = ["22", "80", "443"]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  } # otpravka tolko echo zaprosa

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "My SecurityGroup"
  }
}
