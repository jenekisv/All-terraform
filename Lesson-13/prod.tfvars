# Auto Fill variables for PROD

#File names can be  as:
# terraform.tfvars
# prod.auto.tfvars
# dev.auto.tfvars


region                     = "us-east-1"
instance_type              = "t2.micro"
enable_detailed_monitoring = true

allow_ports = ["22", "80", "443"]

common_tags = {
  Owner       = "Evgenii Sviridov"
  Project     = "Phoenix"
  CostCenter  = "123477"
  Environment = "prod"
}
