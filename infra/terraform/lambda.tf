# Security group for Lambda (allows outbound to DB port)
resource "aws_security_group" "lambda_sg" {
  name   = "${var.project}-lambda-sg"
  vpc_id = aws_vpc.main.id
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = { Name = "${var.project}-lambda-sg" }
}

# allow DB SG to accept from lambda
resource "aws_security_group_rule" "lambda_to_db" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = aws_security_group.db_sg.id
  source_security_group_id = aws_security_group.lambda_sg.id
  description              = "Allow Lambda to connect to RDS MySQL"
}

# Lambda function expects artifact in S3 (CI uploads)
resource "aws_lambda_function" "personas" {
  function_name = "${var.project}-lambda"
  s3_bucket     = var.artifacts_bucket
  s3_key        = var.lambda_s3_key
  handler       = "app.lambda_handler"
  runtime       = "python3.12"
  role          = aws_iam_role.lambda_role.arn
  timeout       = 29

  vpc_config {
    subnet_ids         = aws_subnet.private[*].id
    security_group_ids = [aws_security_group.lambda_sg.id]
  }

  environment {
    variables = {
      SECRETS_ARN = aws_secretsmanager_secret.db_secret.arn
    }
  }
}


