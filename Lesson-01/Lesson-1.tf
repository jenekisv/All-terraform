#----------------------------------------------------------
# My Terraform
#
# Build WebServer during Bootstrap
#
# Made by Evgenii Sviridov 2024
#----------------------------------------------------------


provider "aws" {
  #  access_key = "AKIA....." для примера, но так не делать
  #  secret_key = "TOuz....." для примера, но так не делать
  region = "us-east-1"
}


resource "aws_instance" "my_Ubuntu" {
  count         = 1
  ami           = "ami-080e1f13689e07408"
  instance_type = "t2.micro"

  tags = {
    Name    = "My Ubuntu Server"
    Owner   = "Evgenii Sviridov"
    Project = "Terraform Lessons"
  }
}

resource "aws_instance" "my_Amazon" {
  count         = 1
  ami           = "ami-051f8a213df8bc089"
  instance_type = "t2.micro"

  tags = {
    Name    = "My Amazon Server"
    Owner   = "Evgenii Sviridov"
    Project = "Terraform Lessons"
  }
}
