
resource "aws_cloudwatch_log_group" "service_cloudwatch_log_group" {
  name = "/${var.environment}/batch-job/${var.name}"
}

data "aws_region" "region" {}

resource "aws_batch_job_definition" "batch_job_definition" {
  name = "${var.name}-batch-${var.environment}"
  type = "container"
  platform_capabilities = [
    "FARGATE",
  ]
  container_properties = <<EOF
{
  "entrypoint": ["echo", "Dummy container running"],
  "image": "busybox",
  "fargatePlatformConfiguration": {
    "platformVersion": "LATEST"
  },
  "resourceRequirements": [
    {"type": "VCPU", "value": "0.25"},
    {"type": "MEMORY", "value": "512"}
  ],
  "executionRoleArn": "${var.execution_role_arn}",
  "logConfiguration": {
    "logDriver": "awslogs",
    "options": {
      "awslogs-group": "/${var.environment}/batch-job/${var.name}",
      "awslogs-region": "${data.aws_region.region.name}",
      "awslogs-stream-prefix": "${var.environment}"
    }
  }
}
EOF
  # TODO: Allow to specify job definition and if not provided, use dummy container
  #TODO: Add dynamic blocks for retry_strategy and timeout blocks
  tags = {
    registeredBy = "Terraform"
  }
}

resource "aws_cloudwatch_event_rule" "batch_scheduling_rule" {
  count               = var.enable_cron_scheduling ? 1 : 0
  name                = "${var.name}-batch-${var.environment}-schedule"
  description         = "Schedule ${var.name}-${var.environment} batch job"
  schedule_expression = var.schedule_expression
}

resource "aws_cloudwatch_event_target" "aws_batch_target" {
  count     = var.enable_cron_scheduling ? 1 : 0
  rule      = aws_cloudwatch_event_rule.batch_scheduling_rule[0].name
  target_id = "ScheduleAWSBatchJob"
  arn       = var.batch_queue_arn
  role_arn  = var.batch_submit_job_role_arn
  batch_target {
    job_name       = "${var.name}-batch-${var.environment}"
    job_definition = aws_batch_job_definition.batch_job_definition.arn
  }

  lifecycle {
    ignore_changes = [batch_target[0].job_definition]
  }
}
