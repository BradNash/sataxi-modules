resource "aws_alb" "vanguard_fargate_alb" {
  name               = "${var.lb_name}-${var.environment}"
  subnets            = var.lb_subnets
  security_groups    = [var.vanguard_fargate_alb_sg_id]
  load_balancer_type = var.lb_type
  ip_address_type    = var.lb_address_type
  internal           = var.internal

  access_logs {
    bucket  = "${var.lb_name}-access-logs-${var.environment}"
    prefix  = var.lb_name
    enabled = true
  }

  depends_on = [
    aws_s3_bucket.alb_logs
  ]

  tags = merge(var.tags, {
    Name = "${var.lb_name}-${var.environment}"
  })
}
