resource "aws_kms_key" "kms_key" {
  description = var.repository_name

  tags = {
    Name = var.repository_name
  }
}

resource "aws_codeartifact_domain" "codeartifact_domain" {
  domain         = var.repository_name
  encryption_key = aws_kms_key.kms_key.arn

  tags = {
    Name = var.repository_name
  }
}

resource "aws_codeartifact_repository" "codeartifact_repository" {
  repository = var.repository_name
  domain     = aws_codeartifact_domain.codeartifact_domain.domain

  tags = {
    Name = var.repository_name
  }
}