output "security_group_id" {
  value = aws_security_group.tech_challenge_public_asg.id
  sensitive = true
}