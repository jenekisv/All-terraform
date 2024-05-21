variable "bucket_name" {
  default = "adv-it-terraform-test-bucket-prod"
}

variable "tags" {
  default = {
    Owner       = "Evgenii Sviridov"
    Environment = "prod"
  }
}
