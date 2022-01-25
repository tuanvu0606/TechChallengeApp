variable "vpc_id" {
  type = string
}

variable "ingress_rules" {
  type    = list(string)
  default = []
}

variable "egress_rules" {
  type    = list(string)
  default = [
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
}