variable "environment" {
  description = "The environment for which the RDS should be created for."
  type        = string
}

variable "subnet_ids" {
  description = "Private Subnets for the Fargate cluster."
  type        = list(string)
}

variable "rds_db_name" {
  description = "RDS name"
  type        = string
  default = null
}

variable "rds_port" {
  description = "RDS Port"
  type        = number
  default     = 5432
}

variable "rds_identifier" {
  description = "RDS identifier"
  type        = string
}

variable "rds_engine_type" {
  description = "RDS engine type (mssql, myswl, postgres etc.)"
  type        = string
}

variable "rds_engine_version" {
  description = "RDS engine version, look at aws docs"
  type        = string
}

variable "rds_family" {
  description = "family of rds engine, look at aws docs"
  type        = string
}

variable "major_engine_version" {
  description = "rds engine major version, look at aws docs"
  type        = string
}

variable "username" {
  description = "username of rds instance"
  type        = string
}

variable "instance_class" {
  description = "rds instance class, look at aws docs"
  type        = string
}

variable "allocated_storage" {
  description = "rds allocated storage"
  type        = number
  default     = 20
}

variable "apply_immediately" {
  description = "whether to apply modifications to rds db immediately or in next maintenance window"
  type        = bool
  default     = true
}

variable "deletion_protection" {
  description = "default is false for terraform to delete"
  type        = bool
  default     = false
}

variable "publicly_accessible" {
  description = "whether we can access the db publicly"
  type        = bool
  default     = false
}

variable "maintenance_window" {
  description = "maintenance wondow of db"
  type        = string
  default     = "Mon:00:00-Mon:03:00"
}

variable "backup_window" {
  description = "back up window of db"
  type        = string
  default     = "03:00-06:00"
}

variable "monitoring_interval" {
  description = "monitoring intervals for db"
  type        = string
  default     = "30"
}

variable "monitoring_role_name" {
  description = "iam role for viewing stats on db"
  type        = string
}

variable "create_monitoring_role" {
  description = "whether to create a monitoring role or not"
  type        = bool
  default     = true
}

variable "vpc_security_group_ids" {
  description = "vpc security group ids"
  type        = list(string)
}

variable "backup_retention_period" {
  description = "The days to retain backups for"
  type        = number
}

variable "hosted_zone_id" {
  description = "The hosted zone id in Route53 this db instance should get an alias assigned to"
  type        = string
}

variable "dns_name" {
  description = "The domain name this rds instance should get an alias assigned to"
  type        = string
}

variable "snapshot_identifier" {
  description = "This correlates to the snapshot ID you'd find in the RDS console"
  type        = string
  default     = null
}

variable "storage_encrypted" {
  description = "Specifies whether the DB instance is encrypted"
  default     = false
  type        = bool
}

variable "multi_az" {
  description = "Specifies if the RDS instance is multi-AZ"
  default     = false
  type        = bool
}

variable "tags" {
  description = "A mapping of tags to assign to all resources"
  default     = {}
  type        = map(string)
}


variable "db_subnet_group_name" {
  description = "RDS name of subnet group"
  type        = string
}

