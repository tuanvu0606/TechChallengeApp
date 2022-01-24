output "internet_gateway_id" {
  value = aws_internet_gateway.tech_challenge_my_vpc_igw.id
  sensitive = true
}