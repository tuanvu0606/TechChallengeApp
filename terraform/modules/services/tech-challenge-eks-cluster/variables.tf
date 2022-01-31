variable "name" {
  type = string
}

variable "role_arn" {
  type    = string
}

variable "cluster_version" {
  type    = string
}

# variable "vpc_config" {
#   type = object({
#     security_group_ids = list(string)
#     subnet_ids         = list(string)
#   })
# }

variable "security_group_ids" {
  type = list(string)    
}

variable "subnet_ids" {
  type = list(string)    
}