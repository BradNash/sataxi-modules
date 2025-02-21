variable "source_repo_name" {
  description = "Source repo name"
  type        = string
}

variable "source_repo_branch" {
  description = "Source repo branch"
  default     = "master"
  type        = string
}

variable "source_repo_arn" {
  description = "Source repo ARN"
  type        = string
}

variable "codebuild_iam_policy" {
  description = "Codebuild policy string"
  type        = any
}

variable "codepipeline_iam_policy" {
  description = "CodePipeline assume role policy string"
  type        = any
}

variable "artifact_bucket_name" {
  description = "Name for the s3 artifact bucket"
  type        = string
}

variable "codebuild_environment_variables" {
  description = "Additional environment variables to be used."
  type        = list(map(string))
  default     = []
}

variable "additional_pipelines_stages" {
  description = "Any additional stages to add to the pipeline"
  type        = any
  default     = []
}

variable "tags" {
  default     = {}
  description = "Resource tags"
  type        = map(string)
}
