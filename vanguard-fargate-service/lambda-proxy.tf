module "lambda_proxy" {
  count         = var.create_lambda_proxy ? 1 : 0
  source        = "git::https://github.com/bbdsoftware/terraform-aws-lambda-function?ref=v0.1.2"
  function_name = "${var.service_name}-proxy-${var.environment}"
  description   = "Proxies request body through to the ${var.service_name} service"
  environment = {
    variables = {
      INTERNAL_PROXY_URI = "http://${var.service_name}.${var.service_internal_domain}:${var.container_port}"
    }
  }
  filename  = "proxy.py"
  directory = "lambda"
  handler   = "proxy.lambda_handler"
  runtime   = "python3.9"
  vpc_config = {
    security_group_ids = [var.lambda_proxy_sg_id]
    subnet_ids         = var.subnets
  }
  execution_role_enabled = true
  execution_role_policy = {
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
        ]
        Resource = "arn:aws:logs:af-south-1:*:*"
      },
      {
        Effect = "Allow",
        Action = [
          "ec2:DescribeNetworkInterfaces",
          "ec2:CreateNetworkInterface",
          "ec2:DeleteNetworkInterface",
          "ec2:DescribeInstances",
          "ec2:AttachNetworkInterface"
        ],
        Resource = "*"
      }
    ]
  }
  execution_role_assume_role_policy = {
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Effect = "Allow"
      }
    ]
  }
  execution_role_assume_role_path = "/service-role/"
  lambda_execution_permissions = [
    {
      statement_id   = "AllowAPIGatewayInvoke"
      action         = "lambda:InvokeFunction"
      principal      = "apigateway.amazonaws.com"
      source_arn     = "${var.api_gateway_execution_arn}/*/*/*"
      qualifier      = null
      source_account = null
    }
  ]

  tags = var.tags
}
