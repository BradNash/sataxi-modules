resource "aws_lb_listener" "vanguard_lb_listner" {
  load_balancer_arn = var.vanguard_fargate_alb_arn
  protocol          = var.protocol
  port              = var.port
  certificate_arn   = var.certificate_arn

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Not found"
      status_code  = "404"
    }
  }

  lifecycle {
    ignore_changes = [
      default_action
    ]
  }

  tags = {
    Name = "${var.name}-${var.environment}"
  }
}
