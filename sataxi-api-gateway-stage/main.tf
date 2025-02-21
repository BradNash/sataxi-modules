resource "aws_api_gateway_resource" "resource" {
  rest_api_id = var.api_id
  parent_id   = var.api_root_resource_id
  path_part   = var.path
}

resource "aws_api_gateway_method" "method" {
  authorization    = "NONE"
  api_key_required = var.api_key_required
  http_method      = var.http_method
  resource_id      = aws_api_gateway_resource.resource.id
  rest_api_id      = var.api_id
}

resource "aws_api_gateway_integration" "integration" {
  rest_api_id             = var.api_id
  resource_id             = aws_api_gateway_resource.resource.id
  http_method             = aws_api_gateway_method.method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.integration_uri
}

resource "aws_api_gateway_deployment" "deployment" {
  rest_api_id = var.api_id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.resource.id,
      aws_api_gateway_method.method.id,
      aws_api_gateway_method.method.api_key_required,
      aws_api_gateway_integration.integration.id,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "stage" {
  deployment_id = aws_api_gateway_deployment.deployment.id
  rest_api_id   = var.api_id
  stage_name    = var.environment
}

resource "aws_api_gateway_usage_plan" "usage_plane" {
  name = "${var.api_name}-usage-plan"

  api_stages {
    api_id = var.api_id
    stage  = aws_api_gateway_stage.stage.stage_name
  }
}

resource "aws_api_gateway_api_key" "api_key" {
  count = var.api_key_required ? 1 : 0
  name  = "${var.api_name}-key"
}

resource "aws_api_gateway_usage_plan_key" "usage_plane_key" {
  count         = var.api_key_required ? 1 : 0
  key_id        = aws_api_gateway_api_key.api_key[0].id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.usage_plane.id
}
