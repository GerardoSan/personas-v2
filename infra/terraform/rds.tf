resource "aws_db_subnet_group" "db_subnets" {
  name       = "${var.project}-db-subnet-group"
  subnet_ids = aws_subnet.private[*].id
  tags = { Name = "${var.project}-db-subnet-group" }
}


resource "aws_security_group" "db_sg" {
  name   = "${var.project}-db-sg"
  vpc_id = aws_vpc.main.id
tags = { Name = "${var.project}-db-sg" }
}

# SecretsManager 
resource "random_password" "db_password" {
  length           = 16
  special          = true
  override_special = "!@#$%^&*()_+-=[]{}|'"
  min_upper        = 1
  min_lower        = 1
  min_numeric      = 1
  min_special      = 1
}

resource "aws_secretsmanager_secret" "db_secret" {
  name = "${var.project}-8/db/credentials"
}

resource "aws_secretsmanager_secret_version" "db_secret_version" {
  secret_id = aws_secretsmanager_secret.db_secret.id
  secret_string = jsonencode({
    username = "admin"
    password = random_password.db_password.result
    engine   = var.db_engine
    dbname   = "personasdb"
  })
}

# RDS instance
resource "aws_db_instance" "db" {
  identifier          = "${var.project}-db"
  allocated_storage   = var.db_allocated_storage
  instance_class      = var.db_instance_class
  engine              = var.db_engine
  engine_version      = var.db_engine_version
  db_name             = "personasdb"
  username            = "admin"
  password            = random_password.db_password.result
  db_subnet_group_name = aws_db_subnet_group.db_subnets.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  skip_final_snapshot = true
  publicly_accessible = false
  tags = { Name = "${var.project}-db" }
}
