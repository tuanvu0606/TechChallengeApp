variable "vpc_id" {
  type = string
}

variable "challenge_postgres_db_password" {
  type = string
}

variable "private_subnet_list" {
  type    = list(string)
  default = []
}