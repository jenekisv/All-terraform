variable "bucket_name" {
  default = "adv-it-terraform-test-bucket-root"
}

variable "tags" {
  default = {
    Owner       = "Evgenii Sviridov"
    Environment = "root"
  }
}
