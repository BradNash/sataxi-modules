resource "aws_ecr_repository" "ecr_repos" {
  count                = length(var.ecr_repo_names)
  name                 = var.ecr_repo_names[count.index]
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = var.tags
}

resource "aws_ecr_repository_policy" "ecr_repos" {
  count      = length(aws_ecr_repository.ecr_repos)
  repository = var.ecr_repo_names[count.index]
  policy     = var.ecr_repos_policy
}

resource "aws_ecr_pull_through_cache_rule" "pull_through_cache_rules" {
  count                 = length(var.pull_through_cache_registries)
  ecr_repository_prefix = var.pull_through_cache_registries[count.index].ecr_repository_prefix
  upstream_registry_url = var.pull_through_cache_registries[count.index].upstream_registry_url
}
