variable "paramaters" {
  description = "List of paramater to create"
  type        = list(map(string))
}

variable "tags" {
  default     = {}
  description = "Resource tags"
  type        = map(string)
}
