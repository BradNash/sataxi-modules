variable "environment" {
  description = "The environment for which the MQ should be created for."
  type        = string
}

variable "mq_name" {
  description = "MQ name"
  type        = string
}

variable "mq_username" {
  description = "Admin username"
  type        = string
}

variable "subnet_ids" {
  description = "Private Subnets for the MQ cluster."
  type        = list(string)
}

variable "security_groups_ids" {
  description = "List of security group IDs assigned to the broker."
  type        = list(string)
}

variable "host_instance_type" {
  description = "Instance type for MQ to run on"
  type        = string
}

variable "engine_type" {
  description = "Type of broker engine, ActiveMQ or RabbitMQ"
  type        = string
  default     = "RabbitMQ"
}

variable "engine_version" {
  description = "Broker engine version"
  type        = string
}

variable "deployment_mode" {
  description = "The deployment mode of the broker. Supported: SINGLE_INSTANCE and ACTIVE_STANDBY_MULTI_AZ"
  type        = string
}

variable "maintenance_day_of_week" {
  description = "The maintenance day of the week. e.g. MONDAY, TUESDAY, or WEDNESDAY"
  type        = string
}

variable "maintenance_time_of_day" {
  description = "The maintenance time, in 24-hour format. e.g. 02:00"
  type        = string
}

variable "maintenance_time_zone" {
  description = "The maintenance time zone, in either the Country/City format, or the UTC offset format. e.g. CET"
  type        = string
}

variable "enable_general_logs" {
  description = "Enable General Logs for Rabbit MQ"
  type        = bool
  default     = true
}

variable "tags" {
  default     = {}
  description = "Resource tags"
  type        = map(string)
}
