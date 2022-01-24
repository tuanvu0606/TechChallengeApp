output "tech_challenge_public_ap_southeast_1a_vpc_id" {
  value = aws_subnet.tech_challenge_subnet.vpc_id 
}

output "subnet_id" {
  value = aws_subnet.tech_challenge_subnet.id 
}