resource "aws_security_group" "db_instance_sg" {
  vpc_id      = var.vpc_id
  name        = "db_instance_sg"
  description = "Allow all inbound for Postgres"
ingress =[
   {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [
      "10.0.4.0/24",
      "10.0.7.0/24"     
    ]
  }
]

#   egress = [
#   {
#     cidr_blocks      = [
#       "10.0.4.0/24",
#       "10.0.7.0/24"
#     ]
#     description      = ""
#     from_port        = 0
#     ipv6_cidr_blocks = ["::/0"]
#     prefix_list_ids  = []
#     protocol         = "-1"
#     self             = false
#     to_port          = 0
#   },
# ]
}

resource "aws_db_subnet_group" "tech_db_subnet_group" {
  name       = "main"
  subnet_ids = [
    var.private_subnet_id_1,
    var.private_subnet_id_2
  ]

  tags = {
    Name = "My DB subnet group"
  }
}

resource "aws_db_instance" "tech_challenge_db_instance" {
  identifier             = "tech-challenge-db-instance"
  name                   = "tech_challenge_db_instance_name"
  instance_class         = "db.t2.micro"
  db_subnet_group_name   = aws_db_subnet_group.tech_db_subnet_group.id
  allocated_storage      = 5
  engine                 = "postgres"
  engine_version         = "10.7"
  skip_final_snapshot    = true
  publicly_accessible    = false
  vpc_security_group_ids = [aws_security_group.db_instance_sg.id]
  username               = "postgres"
  password               = var.challenge_postgres_db_password
}