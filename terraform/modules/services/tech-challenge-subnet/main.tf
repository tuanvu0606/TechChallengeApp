
# ------------------------------------------------------- VPC ------------------------------------------------------------- #

resource "aws_subnet" "tech_challenge_public_ap_southeast_1a" {
  # vpc_id     = aws_vpc.my_vpc.id
  vpc_id            = var.vpc_id
  cidr_block        = "10.0.0.0/24"
  availability_zone = "ap-southeast-1a"

  tags = {
    Name = "Public Subnet us-east-1a"
  }
}