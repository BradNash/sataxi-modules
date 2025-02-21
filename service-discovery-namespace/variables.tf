variable "name" {
  description = "Name of the service discovery namespace"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC that fargate resides in"
  type        = string
}
