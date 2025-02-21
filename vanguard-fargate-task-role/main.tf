module "task_role_and_policy" {
  source = "git::https://github.com/bbdsoftware/terraform-service-modules.git//aws-iam-role-and-policy"
  # version = "TODO"

  name   = var.name
  policy = var.policy
  assume_role_policy = {
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          "Service" : "ecs-tasks.amazonaws.com"
        },
        Action    = "sts:AssumeRole"
        Condition = {}
      }
    ]
  }
}

locals {
  aws_managed_policies = [
    "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy",
    "arn:aws:iam::aws:policy/AmazonSQSFullAccess",
    "arn:aws:iam::aws:policy/AWSXRayDaemonWriteAccess"
  ]
}

resource "aws_iam_role_policy_attachment" "task_role_policy_attachment" {
  count      = length(local.aws_managed_policies)
  role       = var.name
  policy_arn = local.aws_managed_policies[count.index]

  depends_on = [
    module.task_role_and_policy
  ]
}
