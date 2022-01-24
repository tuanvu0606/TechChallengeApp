resource "tls_private_key" "tech_challenge_tpk" {
  algorithm = "RSA"
  rsa_bits  = 4096
}