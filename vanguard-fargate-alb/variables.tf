variable "aws_account_id" {
  description = "The AWS Account id"
  type        = string
}

variable "environment" {
  description = "The environment for which the fargate alb should be created for"
  type        = string
}

variable "lb_name" {
  description = "Name of Load Balancer"
  type        = string
}

variable "lb_subnets" {
  description = "Subnets to assign load balancer to"
  type        = list(string)
}

variable "vanguard_fargate_alb_sg_id" {
  description = "Security group id to assign load balancer to"
  type        = string
}

variable "lb_type" {
  description = "Load balancer type"
  default     = "application"
  type        = string
}

variable "internal" {
  description = "Load balancer type"
  default     = true
  type        = bool
}

variable "lb_address_type" {
  description = "Load balancer address type"
  default     = "ipv4"
  type        = string
}

variable "tags" {
  default     = {}
  description = "Resource tags"
  type        = map(string)
}

//-------------------------------------------------------------
//   S3 VARIABLES
//-------------------------------------------------------------

variable "bucket_acl" {
  description = "Access control list for bucket - private or public"
  type        = string
  default     = "private"
}
