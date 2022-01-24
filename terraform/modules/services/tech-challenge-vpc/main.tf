
# ------------------------------------------------------- VPC ------------------------------------------------------------- #

resource "aws_vpc" "tech_challenge_vpc" {
  cidr_block       = var.vpc_ip_range
  instance_tenancy = "default"
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = {
    Name = "Challenge_VPC"
  }
}