resource "aws_ecs_cluster" "vanguard_fargate_cluster" {
  name               = var.cluster_name
  capacity_providers = ["FARGATE", "FARGATE_SPOT"]

  default_capacity_provider_strategy {
    capacity_provider = var.capacity_provider
    weight            = 100
  }

  tags = var.tags
}
