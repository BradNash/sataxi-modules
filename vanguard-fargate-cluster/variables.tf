variable "cluster_name" {
  description = "Name of fargate cluster"
}

variable "capacity_provider" {
  description = "Either FARGATE or FARGATE_SPOT"
  type        = string
}

variable "tags" {
  default     = {}
  description = "Additional resource tags"
  type        = map(string)
}
