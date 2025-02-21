resource "aws_alb_target_group" "vanguard_fargate_alb_target_group" {
  count                         = var.register_with_load_balancer ? 1 : 0
  name                          = "${var.service_name}-${var.environment}-tg"
  port                          = var.container_port
  protocol                      = var.protocol
  vpc_id                        = var.vpc_id
  target_type                   = "ip"
  load_balancing_algorithm_type = var.load_balancing_algorithm_type

  health_check {
    enabled           = var.health_check_enabled
    healthy_threshold = var.health_check_healthy_threshold
    interval          = var.health_check_interval
    path              = var.health_check_path
    port              = var.health_check_port != null ? var.health_check_port : var.container_port
    timeout           = var.health_check_timeout
  }
}

resource "aws_lb_listener_rule" "vanguard_alb_rule" {
  count        = var.register_with_load_balancer ? 1 : 0
  listener_arn = var.lb_listner_arn

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.vanguard_fargate_alb_target_group[0].arn
  }

  condition {
    path_pattern {
      values = ["${var.load_baclancer_path}"]
    }
  }

  condition {
    host_header {
      values = var.service_subdomain == "" ? ["${var.service_name}.${var.service_parent_domain}"] : [
        "${var.service_subdomain}.${var.service_parent_domain}"
      ]
    }
  }
}

resource "aws_cloudwatch_log_group" "service_cloudwatch_log_group" {
  name = "/${var.environment}/service/${var.service_name}"
}

data "aws_region" "region" {}

module "dummy_container_definition" {
  source  = "cloudposse/ecs-container-definition/aws"
  version = "0.58.1"

  log_configuration = {
    logDriver = "awslogs"
    options = {
      awslogs-group         = aws_cloudwatch_log_group.service_cloudwatch_log_group.name
      awslogs-region        = data.aws_region.region.name
      awslogs-stream-prefix = "${var.environment}"
    }
  }
  container_image = "ealen/echo-server"
  container_name  = var.service_name
  port_mappings = var.health_check_port != null ? [
    {
      containerPort = var.health_check_port
      hostPort      = var.health_check_port
      protocol      = "tcp"
    },
    {
      containerPort = var.container_port
      hostPort      = var.container_port
      protocol      = "tcp"
    }
    ] : [
    {
      containerPort = var.container_port
      hostPort      = var.container_port
      protocol      = "tcp"
    }
  ]
  environment = [
    {
      name  = "PORT"
      value = var.health_check_port != null ? var.health_check_port : var.container_port
    },
  ]
}

resource "aws_ecs_task_definition" "vanguard_fargate_task_definition" {
  family                   = "${var.service_name}-${var.environment}"
  task_role_arn            = var.fargate_task_role_arn
  execution_role_arn       = var.fargate_task_execution_role_arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.cpu
  memory                   = var.memory

  container_definitions = jsonencode([
    module.dummy_container_definition.json_map_object
  ])

  lifecycle {
    ignore_changes = all
  }
}

resource "aws_ecs_service" "vanguard_fargate_service" {
  name                               = var.service_name
  cluster                            = var.fargate_cluster_name
  task_definition                    = aws_ecs_task_definition.vanguard_fargate_task_definition.arn
  desired_count                      = var.desired_count
  enable_execute_command             = var.enable_execute_command
  deployment_maximum_percent         = var.deployment_maximum_percent
  deployment_minimum_healthy_percent = var.deployment_minimum_healthy_percent

  lifecycle {
    ignore_changes = [task_definition]
  }

  network_configuration {
    subnets          = var.subnets
    assign_public_ip = false
    security_groups  = [var.fargate_task_sg_id]
  }

  dynamic "service_registries" {
    for_each = aws_service_discovery_service.vangaurd_fargate_ds
    content {
      registry_arn = service_registries.value.arn
      port         = var.container_port
    }
  }

  dynamic "load_balancer" {
    for_each = var.register_with_load_balancer ? [{}] : []
    content {
      target_group_arn = aws_alb_target_group.vanguard_fargate_alb_target_group[0].arn
      container_name   = var.service_name
      container_port   = var.container_port
    }
  }

  capacity_provider_strategy {
    capacity_provider = var.capacity_provider
    weight            = 100
  }

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  tags = var.tags
}

resource "aws_service_discovery_service" "vangaurd_fargate_ds" {
  count = var.create_service_internal_dns || var.create_lambda_proxy ? 1 : 0
  name  = var.service_name
  dns_config {
    namespace_id   = var.service_discovery_ns_id
    routing_policy = "MULTIVALUE"
    dns_records {
      ttl  = 10
      type = "A"

    }
    dns_records {
      ttl  = 10
      type = "SRV"
    }
  }

  health_check_custom_config {
    failure_threshold = 10
  }
}
