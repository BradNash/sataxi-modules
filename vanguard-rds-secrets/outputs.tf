output "secret_arn" {
  value = aws_secretsmanager_secret.master_credentials_secret.arn
}
