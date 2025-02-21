variable "environment" {
  description = "The environment for which the security groups should be created for"
  type        = string
}

variable "fargate_vpc_id" {
  description = "fargate vpc id"
  type        = string
}

variable "fargate_vpc_cidr_block" {
  description = "fargate vpc cidr block"
  type        = string
}

variable "allow_security_groups" {
  description = "Security groups to allow ingress from"
  type        = list(string)
}

variable "tags" {
  default     = {}
  description = "Additional resource tags"
  type        = map(string)
}
