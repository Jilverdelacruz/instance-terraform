ip_vpc_virginia = "192.10.0.0/16"
ip_subnet       = ["192.10.0.0/24", "192.10.1.0/24"]
tags_Virginia = {
  "env"   = "dev"
  "owner" = "Flores"
  "cloud" = "AWS"
  "IAC"   = "Terraform"
}
ip_sg = "0.0.0.0/0"