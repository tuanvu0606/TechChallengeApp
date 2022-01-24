resource "aws_route_table_association" "my_vpc_us_east_1a_public" {
  subnet_id = var.subnet_id
  route_table_id = var.route_table_id
}