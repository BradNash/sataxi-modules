resource "aws_codeartifact_domain" "domain" {
  domain = var.domain
}

resource "aws_codeartifact_repository" "repositories" {
  count      = length(var.repositories)
  repository = var.repositories[count.index].name
  domain     = aws_codeartifact_domain.domain.domain

  external_connections {
    external_connection_name = var.repositories[count.index].external_connection
  }
}

resource "aws_codeartifact_repository_permissions_policy" "permissions_policy" {
  count           = length(var.repositories)
  repository      = aws_codeartifact_repository.repositories[count.index].repository
  domain          = aws_codeartifact_domain.domain.domain
  policy_document = jsonencode(var.permissions_policy)
}
