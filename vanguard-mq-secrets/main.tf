resource "aws_secretsmanager_secret" "master_credentials_secret" {
  name = "rabbit-mq-credentials-${var.environment}"
}

locals {
  ampq_connectiontion_properties = {
    "username" : var.mq_username,
    "password" : var.mq_password,
    "amqp_endpoint" : var.ampq_endpoint,
    "amqp_connection_string" : "amqps://${var.mq_username}:${var.mq_password}@${substr(var.ampq_endpoint, 8, -1)}//"
  }

  tags = var.tags
}

resource "aws_secretsmanager_secret_version" "ampq_master_credentials_secret_version" {
  secret_id     = aws_secretsmanager_secret.master_credentials_secret.id
  secret_string = jsonencode(local.ampq_connectiontion_properties)
}
