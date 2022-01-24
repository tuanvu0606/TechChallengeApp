resource "aws_internet_gateway" "tech_challenge_my_vpc_igw" {
  vpc_id = var.vpc_id

  tags = {
    Name = "Tech Challenge - Internet Gateway"
  }
}