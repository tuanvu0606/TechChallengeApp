
# ------------------------------------------------------- VPC ------------------------------------------------------------- #

resource "aws_subnet" "tech_challenge_subnet" {
  # vpc_id     = aws_vpc.my_vpc.id
  vpc_id            = var.vpc_id
  # cidr_block        = "10.0.0.0/24"
  cidr_block        = var.cidr_block
  availability_zone = var.availability_zone

  tags = {
    # Name = "Public Subnet us-east-1a"
    Name = var.tags_name
  }
}