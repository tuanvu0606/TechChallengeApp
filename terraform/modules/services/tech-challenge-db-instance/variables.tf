variable "identifier" {
  type = string
}

variable "db_subnet_group_name" {
  type = string
}

variable "replicate_source_db" {
  type = string
}

variable "name" {
  type = string
}

variable "instance_class" {
  type = string
}

variable "allocated_storage" {
  type = number
}

variable "engine" {
  type = string
}

variable "engine_version" {
  type = string
}

variable "skip_final_snapshot" {
  type = bool
}

variable "publicly_accessible" {
  type = bool
}

variable "username" {
  type = string
}

# variable "password" {
#   type = string
# }

variable "backup_retention_period" {
  type = number
}

variable "vpc_id" {
  type = string
}

variable "challenge_postgres_db_password" {
  type = string
}

variable "db_instance_sg_id" {
  type = string
}