resource "aws_db_subnet_group" "vanguard_db_subnet_group" {
  name       = "${var.db_subnet_group_name}-${var.environment}"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "vanguard-rds-db-subnet-group-${var.environment}"
  }
}

resource "random_password" "master_password" {
  length  = 16
  special = false
}

module "rds_postgres_instance" {
  source                  = "terraform-aws-modules/rds/aws"
  version                 = "~> 4.3.0"
  vpc_security_group_ids  = var.vpc_security_group_ids
  db_subnet_group_name    = aws_db_subnet_group.vanguard_db_subnet_group.name
  subnet_ids              = var.subnet_ids
  identifier              = "${var.rds_identifier}-${var.environment}"
  db_name                 = var.rds_db_name
  username                = var.username
  password                = random_password.master_password.result
  port                    = var.rds_port
  engine                  = var.rds_engine_type
  engine_version          = var.rds_engine_version
  family                  = var.rds_family //DB parameter group
  major_engine_version    = var.major_engine_version
  instance_class          = var.instance_class
  allocated_storage       = var.allocated_storage
  apply_immediately       = var.apply_immediately
  maintenance_window      = var.maintenance_window
  backup_window           = var.backup_window
  backup_retention_period = var.backup_retention_period
  monitoring_interval     = var.monitoring_interval
  monitoring_role_name    = "${var.monitoring_role_name}-${var.environment}"
  create_monitoring_role  = var.create_monitoring_role
  deletion_protection     = var.deletion_protection
  publicly_accessible     = var.publicly_accessible
  snapshot_identifier     = var.snapshot_identifier
  storage_encrypted       = var.storage_encrypted
  multi_az                = var.multi_az
  tags                    = var.tags
}

resource "aws_db_snapshot" "rds_postgres_snapshot" {
  db_instance_identifier = module.rds_postgres_instance.db_instance_id
  db_snapshot_identifier = "${var.rds_identifier}-${var.environment}" //format("%s-%s", "${var.rds_identifier}-${terraform.workspace}", formatdate("YYYY-MM-DD-hh:mm:ss", timestamp()))
}

resource "aws_route53_record" "route53_entry" {
  zone_id = var.hosted_zone_id
  name    = var.dns_name
  type    = "CNAME"
  ttl     = "300"
  records = [module.rds_postgres_instance.db_instance_address]
}
