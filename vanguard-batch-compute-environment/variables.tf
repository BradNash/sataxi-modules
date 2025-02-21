variable "compute_environment_name" {
  description = "The name for your compute environment."
  type        = string
}

variable "environment" {
  description = "The environment the compute environment and queue are for"
  type        = string
}

variable "max_vcpus" {
  description = "value"
  type        = number
  default     = 16
}

variable "security_group_ids" {
  description = "A list of EC2 security group that are associated with instances launched in the compute environment."
  type        = list(string)
}

variable "subnet_ids" {
  description = "A list of VPC subnet ids into which the compute resources are launched."
  type        = list(string)
}

variable "compute_type" {
  description = "The type of compute environment. Valid items are FARGATE or FARGATE_SPOT."
  type        = string
  default     = "FARGATE"
}

variable "tags" {
  default     = {}
  description = "Resource tags"
  type        = map(string)
}
