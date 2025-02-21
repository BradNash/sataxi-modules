resource "aws_iam_role" "aws_batch_service_role" {
  name = "${var.compute_environment_name}-batch-service-role-${var.environment}"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
    {
        "Action": "sts:AssumeRole",
        "Effect": "Allow",
        "Principal": {
        "Service": "batch.amazonaws.com"
        }
    }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "aws_batch_service_role" {
  role       = aws_iam_role.aws_batch_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBatchServiceRole"
}

resource "aws_batch_compute_environment" "batch_compute_environment" {
  compute_environment_name = "${var.compute_environment_name}-${var.environment}"

  compute_resources {
    max_vcpus          = var.max_vcpus
    security_group_ids = var.security_group_ids
    subnets            = var.subnet_ids
    type               = var.compute_type
  }

  service_role = aws_iam_role.aws_batch_service_role.arn
  type         = "MANAGED"
  depends_on   = [aws_iam_role_policy_attachment.aws_batch_service_role]

  tags = var.tags
}

resource "aws_batch_job_queue" "batch_job_queue" {
  name     = "${var.compute_environment_name}-batch-queue-${var.environment}"
  state    = "ENABLED"
  priority = 1
  compute_environments = [
    aws_batch_compute_environment.batch_compute_environment.arn,
  ]
}
