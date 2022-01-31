resource "aws_db_instance" "tech_challenge_db_instance" {
  identifier             = var.identifier
  replicate_source_db    = var.replicate_source_db
  name                   = var.name
  instance_class         = var.instance_class
  db_subnet_group_name   = var.db_subnet_group_name
  allocated_storage      = var.allocated_storage
  engine                 = var.engine
  engine_version         = var.engine_version
  skip_final_snapshot    = var.skip_final_snapshot
  publicly_accessible    = var.publicly_accessible
  vpc_security_group_ids = [
    var.db_instance_sg_id
  ] 
  username               = var.username
  password               = var.challenge_postgres_db_password
  backup_retention_period = var.backup_retention_period
}