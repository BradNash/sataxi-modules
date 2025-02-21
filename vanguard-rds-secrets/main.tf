resource "aws_secretsmanager_secret" "master_credentials_secret" {
  name = "${var.secret_name}-${var.environment}"
}

locals {
  db_connections = {
    "username" : var.rds_username,
    "password" : var.rds_master_password,
    "engine" : var.rds_engine_type,
    "host" : var.rds_instance_address,
    "port" : var.rds_port,
    "dbClusterIdentifier" : var.cluster_identifier
    "dbname" : var.rds_db_name
  }

  tags = var.tags
}

resource "aws_secretsmanager_secret_version" "rds_master_credentials_secret_version" {
  secret_id     = aws_secretsmanager_secret.master_credentials_secret.id
  secret_string = jsonencode(local.db_connections)
}
