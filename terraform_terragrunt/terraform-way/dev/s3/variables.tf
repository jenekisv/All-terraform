variable "bucket_name" {
  default = "adv-it-terraform-test-bucket-dev"
}

variable "tags" {
  default = {
    Owner       = "Evgenii Sviridov"
    Environment = "dev"
  }
}
