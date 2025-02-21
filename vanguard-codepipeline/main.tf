locals {
  name = replace("${var.source_repo_name}-${var.source_repo_branch}", ".", "_")
}

module "codebuild_iam_role_and_policy" {
  source      = "git::https://github.com/bbdsoftware/terraform-service-modules.git//aws-iam-role-and-policy?ref=main"
  name        = "${local.name}-codebuild-role"
  description = "Role for codebuild to assume"
  policy      = var.codebuild_iam_policy
  assume_role_policy = {
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Principal = {
          "Service" : "codebuild.amazonaws.com"
        },
        Effect = "Allow"
      }
    ]
  }
}

resource "aws_codebuild_project" "codebuild_project" {
  name         = local.name
  service_role = module.codebuild_iam_role_and_policy.role_arn

  artifacts {
    type = "CODEPIPELINE"
  }

  source {
    type = "CODEPIPELINE"
  }

  cache {
    type  = "LOCAL"
    modes = ["LOCAL_DOCKER_LAYER_CACHE", "LOCAL_SOURCE_CACHE"]
  }

  environment {
    compute_type                = "BUILD_GENERAL1_MEDIUM"
    image                       = "aws/codebuild/standard:3.0"
    type                        = "LINUX_CONTAINER"
    privileged_mode             = true
    image_pull_credentials_type = "CODEBUILD"

    dynamic "environment_variable" {
      for_each = var.codebuild_environment_variables
      content {
        name  = environment_variable.value["name"]
        value = environment_variable.value["value"]
        type  = environment_variable.value["type"]
      }
    }
  }

  tags = var.tags
}

module "pipeline_iam_role_and_policy" {
  source      = "git::https://github.com/bbdsoftware/terraform-service-modules.git//aws-iam-role-and-policy?ref=main"
  name        = "${local.name}-codepipeline-role"
  description = "Role for codepipeline to assume"
  policy      = var.codepipeline_iam_policy
  assume_role_policy = {
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Principal = {
          "Service" : "codepipeline.amazonaws.com"
        },
        Effect = "Allow"
      }
    ]
  }
}

resource "aws_codepipeline" "pipeline" {
  name     = local.name
  role_arn = module.pipeline_iam_role_and_policy.role_arn

  artifact_store {
    location = var.artifact_bucket_name
    type     = "S3"
  }

  stage {
    name = "Source"
    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      version          = "1"
      provider         = "CodeCommit"
      output_artifacts = ["SourceOutput"]
      namespace        = "source"
      run_order        = 1
      configuration = {
        RepositoryName       = var.source_repo_name
        BranchName           = var.source_repo_branch
        PollForSourceChanges = "false"
      }
    }
  }

  stage {
    name = "Build"
    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      version          = "1"
      provider         = "CodeBuild"
      input_artifacts  = ["SourceOutput"]
      output_artifacts = ["BuildOutput"]
      namespace        = "build"
      run_order        = 1
      configuration = {
        ProjectName = aws_codebuild_project.codebuild_project.id
      }
    }
  }

  dynamic "stage" {
    for_each = var.additional_pipelines_stages
    content {
      name = stage.value.name
      dynamic "action" {
        for_each = stage.value.actions
        content {
          name             = action.value.name
          category         = action.value.category
          owner            = action.value.owner
          version          = action.value.version
          provider         = action.value.provider
          input_artifacts  = lookup(action.value, "input_artifacts", null)
          output_artifacts = lookup(action.value, "output_artifacts", null)
          namespace        = lookup(action.value, "namespace", null)
          run_order        = lookup(action.value, "run_order", null)
          configuration    = lookup(action.value, "configuration", null)
        }
      }
    }
  }

  tags = var.tags
}

module "pipeline_trigger_iam_role_and_policy" {
  source      = "git::https://github.com/bbdsoftware/terraform-service-modules.git//aws-iam-role-and-policy?ref=main"
  name        = "${local.name}-codepipeline-trigger-role"
  description = "Role to allow access to trigger the pipeline"
  policy = {
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "codepipeline:StartPipelineExecution"
        ],
        Effect   = "Allow",
        Resource = aws_codepipeline.pipeline.arn
      }
    ]
  }
  assume_role_policy = {
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Principal = {
          "Service" : "events.amazonaws.com"
        },
        Effect = "Allow"
      }
    ]
  }
}

resource "aws_cloudwatch_event_rule" "trigger_rule" {
  description   = "Trigger the pipeline when push to specified branch for specified repo"
  event_pattern = <<EOF
{
  "source": [ "aws.codecommit" ],
  "detail-type": [ "CodeCommit Repository State Change" ],
  "resources": ["${var.source_repo_arn}"],
  "detail": {
    "event": [ "referenceCreated", "referenceUpdated" ],
    "referenceType": [ "branch" ],
    "referenceName": [ "${var.source_repo_branch}" ]
  }
}
EOF
  role_arn      = module.pipeline_trigger_iam_role_and_policy.role_arn
  is_enabled    = true
}

resource "aws_cloudwatch_event_target" "target_pipeline" {
  rule      = aws_cloudwatch_event_rule.trigger_rule.name
  arn       = aws_codepipeline.pipeline.arn
  role_arn  = module.pipeline_trigger_iam_role_and_policy.role_arn
  target_id = local.name
}

