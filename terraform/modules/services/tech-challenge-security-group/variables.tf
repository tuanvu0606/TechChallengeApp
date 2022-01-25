variable "vpc_id" {
  type = string
}

variable "ingress_rules" {
  type    = list(object({
    cidr_blocks      = list(string)
    description      = string
    from_port        = number
    ipv6_cidr_blocks = list(string)
    prefix_list_ids  = list(string)
    protocol         = string
    security_groups  = list(string)
    self             = bool
    to_port          = number
  }))
  default = []
}

variable "egress_rules" {
  type    = list(object({
    cidr_blocks      = list(string)
    description      = string
    from_port        = number
    ipv6_cidr_blocks = list(string)
    prefix_list_ids  = list(string)
    protocol         = string
    security_groups  = list(string)
    self             = bool
    to_port          = number
  }))
  default = []
}