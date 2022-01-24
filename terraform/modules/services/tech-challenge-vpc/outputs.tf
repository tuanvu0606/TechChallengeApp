output "tech_challenge_vpc_id" {
  value = aws_vpc.tech_challenge_vpc.id
  sensitive = true
}