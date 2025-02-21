variable "domain" {
  description = "The domain name"
  type        = string
}

variable "repositories" {
  description = "The repositories to create"
  type        = list(map(string))
}

variable "permissions_policy" {
  description = "The permissions policy to apply to the repositories"
  type        = any
}
