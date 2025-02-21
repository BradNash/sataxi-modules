variable "ecr_repo_names" {
  description = "Names of the ECR repos to create"
  type        = list(string)
}

variable "ecr_repos_policy" {
  description = "Repository policy to apply to the ECR repos"
  type        = string
}

variable "pull_through_cache_registries" {
  description = "Names of Pull Through Cache registries"
  type        = any
}

variable "tags" {
  default     = {}
  description = "Resource tags"
  type        = map(string)
}
