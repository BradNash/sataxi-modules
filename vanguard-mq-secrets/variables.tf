variable "environment" {
  description = "The environment to which the mq secrets belongs to"
  type        = string
}

variable "mq_username" {
  description = "MQ username"
  type        = string
}

variable "mq_password" {
  description = "MQ password"
  type        = string
}

variable "ampq_endpoint" {
  description = "AMPQ endpoint"
  type        = string
}

variable "tags" {
  default     = {}
  description = "Resource tags"
  type        = map(string)
}
