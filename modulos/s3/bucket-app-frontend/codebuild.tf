resource "aws_cloudwatch_log_group" "codebuild_pipeline_app" {
  name = "/codebuild/pipeline/app"
}

resource "aws_codebuild_project" "builder_app" {
  name         = "${var.tagname}-BUILDER-APP"
  service_role = aws_iam_role.build_role_app.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  source {
    type     = "CODECOMMIT"
    location = aws_codecommit_repository.codecommit_app.clone_url_http
  }

  source_version = "master"

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:7.0-23.07.28"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    # privileged_mode             = true

    environment_variable {
      name  = "S3_BUCKET"
      value = "s3://${aws_s3_bucket.bucket_app.bucket}"
    }

    environment_variable {
      name  = "DISTRIBUTION_ID_APP"
      value = aws_cloudfront_distribution.distribution_app.id
    }

  }

  logs_config {
    cloudwatch_logs {
      status = "ENABLED"
    }

    s3_logs {
      encryption_disabled = false
      status              = "DISABLED"
    }
  }

  tags = {
    Name = "${var.tagname} APP BUILDER"
  }
}

# output "codebuilder_app_arn" {
#   value = aws_codebuild_project.builder_app.arn
# }
