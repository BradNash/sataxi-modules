resource "aws_ssm_parameter" "ssm_parameter" {
  name        = "/${var.environment}/service/${var.service_name}/config"
  description = "Service config for ${var.service_name}-${var.environment}"
  type        = "SecureString"
  tier        = var.ssm_paramater_tier
  value       = "DUMMY"

  lifecycle {
    ignore_changes = [value]
  }
}
