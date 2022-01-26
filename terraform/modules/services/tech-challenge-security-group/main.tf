resource "aws_security_group" "tech_challenge_public_asg" {
  name        = var.name
  description = "Tech Challenge Public ASG"
  vpc_id      = var.vpc_id

  ingress     = var.ingress_rules

  egress      = var.egress_rules

  tags = {
    Name = "Tech Challenge Public ASG"
  }
}
