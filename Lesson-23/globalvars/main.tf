#----------------------------------------------------------
# My Terraform
#
# Global Variables in Remote State on S3
#
# Made by Evgenii Sviridov 2024
#----------------------------------------------------------
provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "lesson-26-remote-terraform-20"
    key    = "globalvars/terraform.tfstate"
    region = "us-east-1"
  }
}

#==================================================

output "company_name" {
  value = "ANDESA Soft International"
}

output "owner" {
  value = "Evgenii Sviridov"
}

output "tags" {
  value = {
    Project    = "Assembly-2020"
    CostCenter = "R&D"
    Country    = "Canada"
  }
}
