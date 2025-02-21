resource "aws_api_gateway_rest_api" "api_gw_rest_api" {
  name = var.api_gw_name

  body = jsonencode(var.open_api_spec)

  endpoint_configuration {
    types = ["REGIONAL"]
  }

  tags = var.tags
}

resource "aws_api_gateway_deployment" "deployment" {
  rest_api_id = aws_api_gateway_rest_api.api_gw_rest_api.id

  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.api_gw_rest_api.body))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "stage" {
  deployment_id = aws_api_gateway_deployment.deployment.id
  rest_api_id   = aws_api_gateway_rest_api.api_gw_rest_api.id
  stage_name    = var.environment
  # xray_tracing_enabled = true # TODO: Once API Gateway in af-south-1 supports VPC links uncomment this
}

resource "aws_api_gateway_usage_plan" "usage_plane" {
  name = "${var.api_gw_name}-usage-plan"

  api_stages {
    api_id = aws_api_gateway_rest_api.api_gw_rest_api.id
    stage  = aws_api_gateway_stage.stage.stage_name
  }
}

resource "aws_api_gateway_api_key" "api_key" {
  count = length(var.api_key_names)
  name  = "${var.api_key_names[count.index]}-${var.environment}"
}

resource "aws_api_gateway_usage_plan_key" "usage_plane_key" {
  count         = length(var.api_key_names)
  key_id        = aws_api_gateway_api_key.api_key[count.index].id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.usage_plane.id
}

resource "aws_cloudwatch_log_group" "log_group" {
  name              = "API-Gateway-Execution-Logs_${aws_api_gateway_rest_api.api_gw_rest_api.id}"
  retention_in_days = 7
}
