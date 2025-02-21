output "fargate_task_sg_id" {
  value = aws_security_group.vanguard_fargate_task_sg.id
}

output "fargate_vpc_cidr_block" {
  value = var.fargate_vpc_cidr_block
}