resource "random_password" "mq_password" {
  length  = 16
  special = false
}

resource "aws_mq_broker" "mq_broker" {
  broker_name                = "${var.mq_name}-${var.environment}"
  deployment_mode            = var.deployment_mode
  engine_type                = var.engine_type
  engine_version             = var.engine_version
  host_instance_type         = var.host_instance_type
  auto_minor_version_upgrade = true  # TODO:
  apply_immediately          = false # TODO:
  publicly_accessible        = false
  subnet_ids                 = var.subnet_ids

  security_groups = var.security_groups_ids

  # dynamic "encryption_options" {
  #   for_each = var.encryption_enabled ? ["true"] : []
  #   content {
  #     kms_key_id        = var.kms_mq_key_arn
  #     use_aws_owned_key = var.use_aws_owned_key
  #   }
  # } #TODO:

  maintenance_window_start_time {
    day_of_week = var.maintenance_day_of_week
    time_of_day = var.maintenance_time_of_day
    time_zone   = var.maintenance_time_zone
  }

  user {
    username = var.mq_username
    password = random_password.mq_password.result
  }

  logs {
    general = var.enable_general_logs
  }

  tags = var.tags
}
