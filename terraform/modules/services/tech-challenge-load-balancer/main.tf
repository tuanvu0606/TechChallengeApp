# resource "aws_security_group" "elb_http" {
#   name        = "elb_http"
#   description = "Allow HTTP traffic to instances through Elastic Load Balancer"
#   vpc_id = var.vpc_id

#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port       = 0
#     to_port         = 0
#     protocol        = "-1"
#     cidr_blocks     = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name = "Allow HTTP through ELB Security Group"
#   }
# }

resource "aws_elb" "web_elb" {
  name = "web-elb"
  security_groups = var.security_groups
  
  subnets = var.subnet_list

  cross_zone_load_balancing   = true

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    interval = 30
    target = "HTTP:3000/"
  }

  listener {
    lb_port = 80
    lb_protocol = "http"
    instance_port = "3000"
    instance_protocol = "http"
  }

}