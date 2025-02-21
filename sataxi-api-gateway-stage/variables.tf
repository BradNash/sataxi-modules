variable "environment" {
  description = "The environment to create the stage for"
  type        = string
}

variable "path" {
  description = "Path on API Gateway to publish this lambda integration"
  type        = string
}

variable "http_method" {
  description = "The HTTP method for the resource specified by the path"
  type        = string
}

variable "api_key_required" {
  description = "Whether the API resource being created requires an API key or not"
  type        = bool
  default     = false
}

variable "api_id" {
  description = "ID of the API Gateway API"
  type        = string
}

variable "api_name" {
  description = "Name of the API"
  type        = string
}

variable "api_root_resource_id" {
  description = "Root ID of the API Gateway API"
  type        = string
}

variable "integration_type" {
  description = "The integration type for the stage's integration"
  type        = string
  default     = "AWS_PROXY"
}

variable "integration_uri" {
  description = "URI for the integration"
  type        = string
}
