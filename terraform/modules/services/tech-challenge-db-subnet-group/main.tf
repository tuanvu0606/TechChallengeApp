resource "aws_db_subnet_group" "db_subnet_group" {
  name       = var.name
  subnet_ids = var.private_subnet_list

  tags = {
    Name = var.tag_name
  }
}