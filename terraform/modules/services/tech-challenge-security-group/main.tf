resource "aws_security_group" "security_group" {
  name        = var.name
  vpc_id      = var.vpc_id
  ingress     = var.ingress_rules
  egress      = var.egress_rules

  tags = {
    Name = var.tag_name
  }
}
