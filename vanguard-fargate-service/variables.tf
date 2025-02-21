variable "fargate_cluster_name" {
  description = "Fargate Cluster Name"
  type        = string
}

variable "service_name" {
  description = "The name of the Vanguard service"
  type        = string
}

variable "environment" {
  description = "The environment to deploy to."
  type        = string
}

variable "vpc_id" {
  description = "The VPC Id from which the service should be accessible from"
  type        = string
}

variable "create_service_internal_dns" {
  description = "Whether to create a service internal dns name with cloudmap"
  type        = bool
  default     = false
}

variable "service_subdomain" {
  description = "The subdomain of the Vanguard service. If not set, service_name will be used for service subdomain"
  type        = string
  default     = ""
}

variable "subnets" {
  description = "The subnets to deploy the service into. Recommended to use private subnets"
  type        = list(string)
}

variable "desired_count" {
  description = "Desired number of instances"
  default     = 1
  type        = number
}

variable "cpu" {
  description = "CPU allocated to Task"
  default     = "256"
  type        = string
}

variable "memory" {
  description = "Memory allocated to Task"
  default     = "1024"
  type        = string
}

variable "container_port" {
  description = "Port for Container"
  default     = 0
  type        = number
}

variable "enable_execute_command" {
  description = "Exec into Container"
  default     = false
  type        = bool
}

variable "fargate_task_role_arn" {
  description = "Vanguard Services Default Role"
  type        = string
}

variable "fargate_task_execution_role_arn" {
  description = "Vanguard Services Default Role"
  type        = string
}

variable "fargate_task_sg_id" {
  description = "fargate task id"
  type        = string
}

variable "service_discovery_ns_id" {
  description = "service discovery id"
  type        = string
}

variable "service_parent_domain" {
  description = "The dns domain the service is apart of"
  type        = string
  default     = ""
}

variable "register_with_load_balancer" {
  description = "whether to register with a laod balancer or not"
  default     = true
  type        = bool
}

variable "capacity_provider" {
  description = "Either FARGATE or FARGATE_SPOT"
  type        = string
}

variable "protocol" {
  description = "protocol"
  default     = "HTTP"
  type        = string
}

variable "load_balancing_algorithm_type" {
  description = "Name of Load Algorithm Type"
  default     = "round_robin"
  type        = string
}

variable "health_check_enabled" {
  description = "Health Checker enabled/not"
  default     = true
  type        = bool
}

variable "health_check_healthy_threshold" {
  description = "Health Threshold"
  default     = 3
  type        = number
}

variable "health_check_interval" {
  description = "Health Check Interval"
  default     = 30
  type        = number
}

variable "health_check_path" {
  description = "Health Check Path"
  default     = "/health_check"
  type        = string
}

variable "health_check_port" {
  description = "Health Check Port"
  default     = null
  type        = number
}

variable "health_check_timeout" {
  description = "Health Check Timeout"
  default     = 5
  type        = number
}

variable "load_baclancer_path" {
  description = "Path for service to be registered on the load balancer"
  type        = string
  default     = "/*"
}

variable "lb_listner_arn" {
  description = "vanguard alb listner ARN"
  type        = string
  default     = ""
}

variable "ssm_paramater_tier" {
  description = "Tier for AWS ssm paramater to create"
  type        = string
  default     = "Standard"
}

variable "create_lambda_proxy" {
  description = "Whether to create a lambda proxy in the VPC specified by vpc_id to allow proxy from API Gateway"
  type        = bool
  default     = false
}

variable "lambda_proxy_sg_id" {
  description = "The ID of the security group to attach to the lambda proxy if it is created"
  type        = string
  default     = ""
}

variable "service_internal_domain" {
  description = "The internal domain to which the service could be registered to"
  type        = string
  default     = ""
}

variable "api_gateway_execution_arn" {
  description = "Execution ARN of API Gateway which allows API Gatewat permissions to invoke the lambda proxy"
  type        = string
  default     = ""
}

variable "deployment_maximum_percent" {
  description = "Maximum deployment percentage"
  type        = number
  default     = 200
}

variable "deployment_minimum_healthy_percent" {
  description = "Minimum deployment percentage"
  default     = 100
  type        = number
}

variable "tags" {
  default     = {}
  description = "Additional resource tags"
  type        = map(string)
}

