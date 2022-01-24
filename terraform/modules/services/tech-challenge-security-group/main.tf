resource "aws_security_group" "tech_challenge_public_asg" {
  name        = "tech_challenge_public_asg"
  description = "Tech Challenge Public ASG"
  vpc_id      = var.vpc_id

ingress = [
  {
    cidr_blocks      = ["0.0.0.0/0",]
    description      = ""
    from_port        = 22
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    protocol         = "tcp"
    security_groups  = []
    self             = false
    to_port          = 22
  },
  {
    cidr_blocks      = ["0.0.0.0/0",]
    description      = ""
    from_port        = 3000
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    protocol         = "tcp"
    security_groups  = []
    self             = false
    to_port          = 3000
  },
  {
    cidr_blocks      = ["0.0.0.0/0",]
    description      = ""
    from_port        = 80
    ipv6_cidr_blocks = ["::/0",]
    prefix_list_ids  = []
    protocol         = "tcp"
    security_groups  = []
    self             = false
    to_port          = 80
  } 
]

  egress = [
  {
    cidr_blocks      = ["0.0.0.0/0"]
    description      = ""
    from_port        = 0
    ipv6_cidr_blocks = ["::/0"]
    prefix_list_ids  = []
    protocol         = "-1"
    security_groups  = []
    self             = false
    to_port          = 0
  },
]

  tags = {
    Name = "Tech Challenge Public ASG"
  }
}
