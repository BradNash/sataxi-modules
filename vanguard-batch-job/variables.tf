variable "name" {
  description = "Specifies the name of the job definition."
  type        = string
}

variable "environment" {
  description = "The environment for the batch job"
  type        = string
}

variable "execution_role_arn" {
  description = "Execution role for the batch job"
  type        = string
}

variable "enable_cron_scheduling" {
  description = "Enable cron scheduling"
  type        = bool
  default     = false
}

variable "schedule_expression" {
  description = "Scheduling expression for EventBridge Rule. For example, cron(0 20 * * ? *) or rate(5 minutes)"
  type        = string
  default     = ""
}

variable "batch_submit_job_role_arn" {
  description = "IAM role to assume to schedule AWS batch jobs with"
  type        = string
  default     = ""
}

variable "batch_queue_arn" {
  description = "Batch Queue ARN to submit job to using EventBridge if enable_cron_scheduling is set to true"
  type        = string
  default     = ""
}
