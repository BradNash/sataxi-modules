resource "aws_ssm_parameter" "ssm_parameter" {
  count       = length(var.paramaters)
  name        = var.paramaters[count.index].name
  description = var.paramaters[count.index].description
  type        = "SecureString"
  tier        = "Standard"
  value       = lookup(var.paramaters[count.index], "value", "DUMMY")

  lifecycle {
    ignore_changes = all
  }
}
