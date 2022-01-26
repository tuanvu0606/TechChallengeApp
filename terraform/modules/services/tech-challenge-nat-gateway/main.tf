resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.test.id
  subnet_id     = var.subnet_id

  tags = {
    Name = "gw NAT"
  }
}

resource "aws_eip" "test" {
  vpc      = true
}