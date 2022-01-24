# variable key_name {
#   type = string
#   # default = "challenge_tls_key"
#   description = "name of the tls key, can be feed from modules"
# }

variable vpc_ip_range {
  type = string
  default = "10.0.0.0/16"
  description = "VPC Ip range"
}
