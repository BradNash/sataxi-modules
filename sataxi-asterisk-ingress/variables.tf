variable "main_vpc_id" {
  description = "fargate vpc id"
  type        = string
}

variable "environment" {
  description = "Environment the asterisk ingresses need to be deployed to"
  type        = string
}

variable "alb_listener_arn" {
  description = "alb listner arn"
  type        = string
}

variable "asterisk_instance_id" {
  description = "asterisk ec2 instance id"
  type        = string
}

variable "service_parent_domain" {
  description = "Parent domain the ingresses are apart of"
  type        = string
}
