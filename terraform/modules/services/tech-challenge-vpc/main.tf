
# ------------------------------------------------------- VPC ------------------------------------------------------------- #

resource "aws_vpc" "tech_challenge_vpc" {
  cidr_block       = var.vpc_ip_range
  instance_tenancy = "default"

  tags = {
    Name = "Challenge_VPC"
  }
}