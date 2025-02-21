resource "aws_service_discovery_private_dns_namespace" "service_discovery_namespace" {
  name = var.name
  vpc  = var.vpc_id
}
