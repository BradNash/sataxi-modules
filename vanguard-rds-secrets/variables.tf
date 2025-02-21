variable "environment" {
  description = "The environment to which the rds secrets belongs to"
  type        = string
}

variable "cluster_identifier" {
  description = "The cluster to which these secrets apply to"
  type        = string
}

variable "rds_username" {
  description = "username of rds instance"
  type        = string
  sensitive   = true
}

variable "secret_name" {
  description = "Name of Secret"
  type        = string
}

variable "rds_master_password" {
  description = "RDS engine type (mssql, mysql, postgres etc.)"
  type        = string
  sensitive   = true
}

variable "rds_port" {
  description = "RDS Port"
  type        = number
}

variable "rds_db_name" {
  description = "RDS name"
  type        = string
}

variable "rds_engine_type" {
  description = "RDS engine type (mssql, mysql, postgres etc.)"
  type        = string
}

variable "rds_instance_address" {
  description = "RDS address"
  type        = string
}

variable "tags" {
  default     = {}
  description = "Resource tags"
  type        = map(string)
}
