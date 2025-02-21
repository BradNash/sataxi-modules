resource "aws_security_group" "vanguard_rds_security_group" {
  name        = "${var.security_group_name}-${var.environment}"
  description = var.security_group_description
  vpc_id      = var.fargate_vpc_id

  ingress = [
    {
      from_port        = 5432
      to_port          = 5432
      protocol         = "tcp"
      description      = "Postgres access from within VPC"
      security_groups  = [var.fargate_task_id]
      cidr_blocks      = null
      ipv6_cidr_blocks = null
      prefix_list_ids  = null
      self             = null
    },
    { // Temmporary
      from_port        = 5432
      to_port          = 5432
      protocol         = "tcp"
      description      = "Postgres access from within VPC"
      security_groups  = null
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = null
      prefix_list_ids  = null
      self             = null
    }, ]
  tags = {
    Name = "vanguard-rds-postgres-sg-${var.environment}"
  }
}


resource "aws_security_group" "vanguard_rds_access_sg" {
  name        = "vanguard-rds-access-sg-${var.environment}"
  description = "controls access to the RDS"
  vpc_id      = var.fargate_vpc_id

  ingress = [
    {
      from_port        = 5432
      to_port          = 5432
      protocol         = "tcp"
      description      = "Postgres access from within VPC"
      security_groups  = [var.fargate_task_id]
      cidr_blocks      = null
      ipv6_cidr_blocks = null
      prefix_list_ids  = null
      self             = null
    },
    {
      from_port        = 443
      to_port          = 443
      protocol         = "tcp"
      description      = "HTTP access from within VPC"
      security_groups  = [var.fargate_task_id]
      cidr_blocks      = null
      ipv6_cidr_blocks = null
      prefix_list_ids  = null
      self             = null
    },
    { // Temmporary
      from_port        = 5432
      to_port          = 5432
      protocol         = "tcp"
      description      = "Postgres access from within VPC"
      security_groups  = null
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = null
      prefix_list_ids  = null
      self             = null
    }
  ]

  tags = {
    Name = "vanguard-rds-access-sg-${var.environment}"
  }
}
