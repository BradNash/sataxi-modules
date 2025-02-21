output "lambda_proxy_invoke_arn" {
  value = var.create_lambda_proxy ? module.lambda_proxy[0].lambda_invoke_arn : ""
}
