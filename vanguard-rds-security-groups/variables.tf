variable "environment" {
  description = "The environment the rds DB belongs to"
  type        = string
}

variable "fargate_vpc_id" {
  description = "fargate vpc"
  type        = string
}

variable "fargate_task_id" {
  description = "Task Security Group"
  type        = string
}

variable "security_group_name" {
  description = "Security Group name"
  type        = string
}

variable "security_group_description" {
  description = "Security Group description"
  type        = string
}
