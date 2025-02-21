module "task_execution_role_and_policy" {
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

resource "aws_iam_role_policy_attachment" "task-execution-role-policy-attachment" {
  role       = var.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"

  depends_on = [
    module.task_execution_role_and_policy
  ]
}
