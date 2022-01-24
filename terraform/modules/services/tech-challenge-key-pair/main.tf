resource "tls_private_key" "tech_challenge_tpk" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "tech_challenge_akp" {
  key_name   = "tech_challenge_akp_key"
  public_key = tls_private_key.tech_challenge_tpk.public_key_openssh
}
