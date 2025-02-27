# ---------------------------------------------------------------------------------------------------------------------
# AWS DEFAULT VARIABLES
# ---------------------------------------------------------------------------------------------------------------------
variable "aws_account_id" {
  type = string
}

variable "aws_region" {
  description = "The AWS region to create things in."
  default     = "af-south-1"
}

variable "azs" {
  type = list(any)
}
# ---------------------------------------------------------------------------------------------------------------------
# DEFAULT VARIABLES
# ---------------------------------------------------------------------------------------------------------------------

variable "repository_name" {
  description = "Repository Name"
  type = string
}
