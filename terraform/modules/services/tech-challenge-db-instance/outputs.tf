output "endpoint" {
  value = aws_db_instance.tech_challenge_db_instance.endpoint
}

output "address" {
  value = aws_db_instance.tech_challenge_db_instance.address
}

output "port" {
  value = aws_db_instance.tech_challenge_db_instance.port
}

output "id" {
  value = aws_db_instance.tech_challenge_db_instance.id
  sensitive = true
}