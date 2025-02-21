
resource "aws_security_group" "vanguard_fargate_ecr_sg" {
  name        = "vanguard-ecr-sg-${var.environment}"
  description = "ECR Security Group"
  vpc_id      = var.fargate_vpc_id

  ingress {
    protocol    = "ALL"
    from_port   = 0
    to_port     = 0
    cidr_blocks = [var.fargate_vpc_cidr_block]
  }

  tags = merge(
    var.tags,
    {
      Name        = "vanguard-ecr-sg-${var.environment}"
      Environment = var.environment
    },
  )
}
