variable "name" {
  type        = string
  description = "The name of the role and the policy"
}

variable "policy" {
  type        = any
  description = "An object representing the permissions policy which will be converted to JSON"
}
