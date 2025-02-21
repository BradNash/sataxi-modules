variable "api_gw_name" {
  description = "Name of the API GW resource"
  type        = string
}

variable "open_api_spec" {
  description = "Open API Spec"
  type        = any
}

variable "environment" {
  description = "The environment to create the stage for"
  type        = string
}

variable "api_key_names" {
  description = "List of API key names to provision"
  type        = list(string)
}

variable "tags" {
  default     = {}
  description = "Resource tags"
  type        = map(string)
}
