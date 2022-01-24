variable vpc_ip_range {
  type = string
  default = "10.0.0.0/16"
  description = "VPC Ip range"
}

variable "enable_dns_hostnames" {
  default = true
}