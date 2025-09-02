resource "aws_iam_role" "lambda_role" {
  name = "${var.project}-lambda-role"

  assume_role_policy = data.aws_iam_policy_document.lambda_assume.json
}

data "aws_iam_policy_document" "lambda_assume" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

# Attach policies: CloudWatch Logs & SecretsManager read
resource "aws_iam_role_policy_attachment" "cw_logs" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_policy" "secrets_read_policy" {
  name   = "${var.project}-secrets-read"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = ["secretsmanager:GetSecretValue"],
        Resource = aws_secretsmanager_secret.db_secret.arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "secrets_read_attach" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.secrets_read_policy.arn
}

