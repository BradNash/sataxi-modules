variable "name" {
  description = "Name of Target Group"
  type        = string
}

variable "environment" {
  description = "Environment to which the listener belongs"
  type        = string
}

variable "port" {
  description = "Name of Target Group Port"
  default     = 443
  type        = number
}

variable "protocol" {
  description = "Name of Target Group Protocol"
  default     = "HTTPS"
  type        = string
}

variable "vanguard_fargate_alb_arn" {
  description = "Fargate ALB ARN"
  type        = string
}

variable "certificate_arn" {
  description = "Certificate ARN"
  type        = string
}

variable "action_type" { # TODO: Not used
  description = "action type"
  type        = string
  default     = "redirect"
}

variable "status_code" { # TODO: Not used
  description = "status code"
  type        = string
  default     = "HTTP_301"
}

