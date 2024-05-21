#----------------------------------------------------------
# My Terraform
#
# Terraform Conditions and Lookups
#
# Made by Evgenii Sviridov 2024
#----------------------------------------------------------

provider "aws" {
  region = "us-east-1"
}

resource "aws_default_vpc" "default" {} # This need to be added since AWS Provider v4.29+ to get VPC id

// Use of Condition
resource "aws_instance" "my_webserver1" {
  ami = "ami-051f8a213df8bc089"
  //instance_type = (var.env == "prod" ? "t2.large" : "t2.micro")
  instance_type = var.env == "prod" ? var.ec2_size["prod"] : var.ec2_size["dev"]

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "optional"
  } # chtobi rabotali IMDSv1 "/meta-data/local-ipv4"

  tags = {
    Name  = "${var.env}-server"
    Owner = var.env == "prod" ? var.prod_onwer : var.noprod_owner
  }
}

// Use of LOOKUP
resource "aws_instance" "my_webserver2" {
  ami           = "ami-051f8a213df8bc089"
  instance_type = lookup(var.ec2_size, var.env)

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "optional"
  } # chtobi rabotali IMDSv1 "/meta-data/local-ipv4"

  tags = {
    Name  = "${var.env}-server"
    Owner = var.env == "prod" ? var.prod_onwer : var.noprod_owner
  }
}


// Create Bastion ONLY for if "dev" environment
resource "aws_instance" "my_dev_bastion" {
  count         = var.env == "dev" ? 1 : 0
  ami           = "ami-051f8a213df8bc089"
  instance_type = "t2.micro"

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "optional"
  } # chtobi rabotali IMDSv1 "/meta-data/local-ipv4"

  tags = {
    Name = "Bastion Server for Dev-server"
  }
}



resource "aws_security_group" "my_webserver" {
  name   = "Dynamic Security Group"
  vpc_id = aws_default_vpc.default.id # This need to be added since AWS Provider v4.29+ to set VPC id

  dynamic "ingress" {
    for_each = lookup(var.allow_port_list, var.env)
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
    Name  = "Dynamic SecurityGroup"
    Owner = "Denis Astahov"
  }
}
