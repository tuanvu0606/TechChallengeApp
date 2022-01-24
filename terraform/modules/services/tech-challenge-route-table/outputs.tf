output "route_table_id" {
  value = aws_route_table.challenge_route_table.id
  sensitive = true
}