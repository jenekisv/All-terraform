#----------------------------------------------------------
# My Terraform
#
# Use Global Variables from Remote State
#
# Made by Evgenii Sviridov 2024
#----------------------------------------------------------

provider "aws" {
  region = "us-east-1"
}

data "terraform_remote_state" "global" {
  backend = "s3"
  config = {
    bucket = "lesson-26-remote-terraform-20"
    key    = "globalvars/terraform.tfstate"
    region = "us-east-1"
  }
}

locals {
  company_name = data.terraform_remote_state.global.outputs.company_name
  owner        = data.terraform_remote_state.global.outputs.owner
  common_tags  = data.terraform_remote_state.global.outputs.tags
}
#---------------------------------------------------------------------

resource "aws_vpc" "vpc1" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name    = "Stack1-VPC1"
    Company = local.company_name
    Owner   = local.owner
  }
}


resource "aws_vpc" "vpc2" {
  cidr_block = "10.0.0.0/16"
  tags       = merge(local.common_tags, { Name = "Stack1-VPC2" })
}
