output "tls_private_key_pem_content" {
  value = tls_private_key.tech_challenge_tpk.private_key_pem
  sensitive = true
}

output "key_id" {
  value = tls_private_key.tech_challenge_tpk.id
}