variable "load_balancer_id" {
  type = string
}

variable "launch_configuration_name" {
  type = string
}

variable "public_subnet_list" {
  type    = list(string)
  default = []
}
