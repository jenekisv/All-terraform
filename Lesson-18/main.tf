#----------------------------------------------------------
# My Terraform
#
# Terraform Loops: Count and For if
#
# Made by Evgenii Sviridov 2024
#----------------------------------------------------------
provider "aws" {
  region = "us-east-1"
}


resource "aws_iam_user" "user1" {
  name = "pushkin"
}

resource "aws_iam_user" "users" {
  count = length(var.aws_users)
  name  = element(var.aws_users, count.index)
}

#----------------------------------------------------------------

resource "aws_instance" "servers" {
  count         = 3
  ami           = "ami-051f8a213df8bc089"
  instance_type = "t2.micro"
  tags = {
    Name = "Server Number ${count.index + 1}"
  }
}
