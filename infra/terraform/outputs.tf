output "api_endpoint" {
  value = aws_apigatewayv2_api.http_api.api_endpoint
}

output "db_endpoint" {
  value = aws_db_instance.db.endpoint
}

output "db_secret_arn" {
  value = aws_secretsmanager_secret.db_secret.arn
}

