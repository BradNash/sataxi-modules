resource "aws_alb_target_group" "freepbx_alb_target_group" {
  name        = "freebpx-management-${var.environment}-tg"
  port        = 443
  protocol    = "HTTPS"
  vpc_id      = var.main_vpc_id
  target_type = "instance"

  load_balancing_algorithm_type = "round_robin"

  health_check {
    enabled           = true
    healthy_threshold = 3
    interval          = 30
    path              = "/admin/config.php"
    port              = "traffic-port"
    timeout           = 5
    protocol          = "HTTPS"

  }

  tags = {
    Name = "freepbx-management-${var.environment}-tg"
  }
}

resource "aws_lb_listener_rule" "freebpx_listener_rule" {
  listener_arn = var.alb_listener_arn

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.freepbx_alb_target_group.arn
  }

  condition {
    path_pattern {
      values = ["/*"]
    }
  }

  condition {
    host_header {
      values = ["freepbx-management.${var.service_parent_domain}"]
    }
  }
}

resource "aws_lb_target_group_attachment" "freepbx_alb_target_attachment" {
  target_group_arn = aws_alb_target_group.freepbx_alb_target_group.arn
  target_id        = var.asterisk_instance_id
  port             = 443
}

resource "aws_alb_target_group" "asterisk_alb_target_group" {
  name        = "asterisk-${var.environment}-tg"
  port        = 8089
  protocol    = "HTTPS"
  vpc_id      = var.main_vpc_id
  target_type = "instance"

  load_balancing_algorithm_type = "round_robin"

  health_check {
    enabled           = true
    healthy_threshold = 3
    interval          = 90
    path              = "/static/mantest.html"
    port              = "traffic-port"
    timeout           = 5
    protocol          = "HTTPS"
  }

  tags = {
    Name = "asterisk-${var.environment}-tg"
  }
}

resource "aws_lb_listener_rule" "vanguard_alb_rule" {
  listener_arn = var.alb_listener_arn

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.asterisk_alb_target_group.arn
  }

  condition {
    path_pattern {
      values = ["/*"]
    }
  }

  condition {
    host_header {
      values = ["asterisk.${var.service_parent_domain}"]
    }
  }
}

resource "aws_lb_target_group_attachment" "asterisk_alb_target_attachment" {
  target_group_arn = aws_alb_target_group.asterisk_alb_target_group.arn
  target_id        = var.asterisk_instance_id
  port             = 8089
}
