output "db_instance_password" {
  value     = module.rds_postgres_instance.db_instance_password
  sensitive = true
}

output "db_instance_name" {
  value = module.rds_postgres_instance.db_instance_name
}

output "db_instance_address" {
  value = aws_route53_record.route53_entry.name
}

output "db_instance_username" {
  value     = module.rds_postgres_instance.db_instance_username
  sensitive = true
}

output "db_instance_port" {
  value = module.rds_postgres_instance.db_instance_port
}

output "db_instance_type" {
  value = var.rds_engine_type
}
