output "vanguard_fargate_alb_arn" {
  value = aws_alb.vanguard_fargate_alb.arn
}

output "vanguard_fargate_alb_dns_name" {
  value = aws_alb.vanguard_fargate_alb.dns_name
}

output "vanguard_fargate_alb_zone_id" {
  value = aws_alb.vanguard_fargate_alb.zone_id
}
