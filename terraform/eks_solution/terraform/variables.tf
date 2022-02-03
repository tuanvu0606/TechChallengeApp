variable "eks_solution" {
  description = "If set to true, use eks solution"
  type        = bool
  default     = false
}

variable "challenge_postgres_db_password" {
  description = "This is another example input variable using env variables."
  type        = string
}

variable "eks_solution_region" {
  description = "region of eks solution"
  type        = string
  default     = false
}
