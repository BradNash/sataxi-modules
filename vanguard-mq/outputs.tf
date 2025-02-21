output "mq_username" {
  value     = var.mq_username
  sensitive = true
}

output "mq_password" {
  value     = random_password.mq_password.result
  sensitive = true
}

output "amqp_endpoint" {
  value = aws_mq_broker.mq_broker.instances[0].endpoints[0]
}
