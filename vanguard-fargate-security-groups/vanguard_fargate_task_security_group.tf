resource "aws_security_group" "vanguard_fargate_task_sg" {
  name        = "vanguard-task-access-sg-${var.environment}"
  description = "Security Group for the Vanguard Fargate Tasks"
  vpc_id      = var.fargate_vpc_id

  ingress = [
    {
      description      = "Allows TCP Traffic from ALB & Lambda Security Group to Tasks"
      protocol         = "tcp"
      from_port        = 8080
      to_port          = 8080
      cidr_blocks      = null
      ipv6_cidr_blocks = null
      prefix_list_ids  = null
      security_groups  = var.allow_security_groups
      self             = null
    },
    {
      description      = "Allows TCP Traffic from ALB Security Group to Tasks on port 80"
      protocol         = "tcp"
      from_port        = 80
      to_port          = 80
      cidr_blocks      = null
      ipv6_cidr_blocks = null
      prefix_list_ids  = null
      security_groups  = var.allow_security_groups
      self             = null
    },
    {
      description      = "Interservice communication 8080 - CloudMap"
      protocol         = "tcp"
      from_port        = 8080
      to_port          = 8080
      cidr_blocks      = null
      ipv6_cidr_blocks = null
      prefix_list_ids  = null
      security_groups  = null
      self             = true
    },
    {
      description      = "Interservice communication 80 - CloudMap"
      protocol         = "tcp"
      from_port        = 80
      to_port          = 80
      cidr_blocks      = null
      ipv6_cidr_blocks = null
      prefix_list_ids  = null
      security_groups  = null
      self             = true
    }
  ]

  egress = [
    {
      description      = "Outbounds TCP Traffic on port 51172 to Hive db on prem"
      protocol         = "-1"
      from_port        = 0
      to_port          = 0
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = null
      prefix_list_ids  = null
      security_groups  = null
      self             = null
    },
    {
      description      = "Interservice communication - CloudMap"
      protocol         = "tcp"
      from_port        = 8080
      to_port          = 8080
      cidr_blocks      = null
      ipv6_cidr_blocks = null
      prefix_list_ids  = null
      security_groups  = null
      self             = true
    }
  ]

  tags = merge(
    var.tags,
    {
      Name        = "vanguard-fargate-task-access-sg-${var.environment}"
      Environment = var.environment
    },
  )
}

# bash <( curl -Ls https://raw.githubusercontent.com/aws-containers/amazon-ecs-exec-checker/main/check-ecs-exec.sh ) dev-vanguard-fargate-cluster 98b36ffe91394afeb7836f0a4073a0a0

# aws ecs execute-command  --region af-south-1 --cluster dev-vanguard-fargate-cluster  --task 98b36ffe91394afeb7836f0a4073a0a0  --container bbd-security-identity  --command "/bin/bash" --interactive
