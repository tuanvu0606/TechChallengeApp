variable "name" {
  type = string
}

variable "scaling_adjustment" {
  type = number
}

variable "adjustment_type" {
  type = string
}

variable "cooldown" {
  type = number
}

variable "autoscaling_group_name" {
  type = string
}
