output "tech_tls_private_key_pem_content" {
  value = tls_private_key.tech_challenge_tpk.private_key_pem
  sensitive = true
}

output "key_name" {
  value = aws_key_pair.tech_challenge_akp.key_name
  sensitive = true
}