variable "vpc_id" {
  type = string
}

variable "subnet_list" {
  type    = list(string)
  default = []
}

variable "security_groups" {
  type    = list(string)
  default = []  
}