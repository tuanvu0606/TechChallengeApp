resource "aws_db_subnet_group" "tech_db_subnet_group" {
  name       = "main"
  subnet_ids = var.private_subnet_list

  tags = {
    Name = "My DB subnet group"
  }
}

resource "aws_db_instance" "tech_challenge_db_instance" {
  identifier             = "tech-challenge-db-instance"
  name                   = "TechAppDB"
  instance_class         = "db.t2.micro"
  db_subnet_group_name   = aws_db_subnet_group.tech_db_subnet_group.id
  allocated_storage      = 5
  engine                 = "postgres"
  engine_version         = "9.6"
  skip_final_snapshot    = true
  publicly_accessible    = false
  vpc_security_group_ids = [
    var.db_instance_sg_id
  ] 
  username               = "postgres"
  password               = var.challenge_postgres_db_password
} 