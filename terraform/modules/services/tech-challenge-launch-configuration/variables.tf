variable "key_name" {
  type = string
  # default = "challenge_tls_key"
  description = "name of the tls key, can be feed from modules"
}

variable "security_group_id" {
  type = string
}

variable "database_host" {
  type = string
}

variable "database_port" {
  type = string
}

variable "database_password" {
  type = string
}


