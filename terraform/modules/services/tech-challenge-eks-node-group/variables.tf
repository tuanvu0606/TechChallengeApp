variable "cluster_name" {
  type = string
}

variable "node_group_name" {
  type    = string
  default = ""
}

variable "node_role_arn" {
  type    = string
  default = ""
}

variable "tags" {
  type    = object({  
    Name = string
  })
  default = {
    Name = "Cool1"
  }
}

variable "subnet_ids" {
  type    = list(string)
  # default = ""
}

variable "instance_types" {
  type    = list(string)
  default = null
}

variable "desired_size" {
  type    = number
  default = 1
}

variable "max_size" {
  type    = number
  default = 1
}

variable "min_size" {
  type    = number
  default = 1
}
