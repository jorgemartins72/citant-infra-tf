resource "aws_cloudwatch_log_group" "codebuild_pipeline_worker" {
  name = "/codebuild/pipeline/worker"
}

resource "aws_codebuild_project" "builder_worker" {
  name         = "${var.tagname}-BUILDER-WORKER-IMAGE"
  service_role = aws_iam_role.build_role_worker.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  source {
    type     = "CODECOMMIT"
    location = aws_codecommit_repository.codecommit_worker.clone_url_http
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:7.0-23.07.28"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true

    environment_variable {
      name  = "DOCKERHUB_USERNAME"
      value = var.docker_username
    }

    environment_variable {
      name  = "DOCKERHUB_PASS"
      value = var.docker_userpass
    }
  }

  source_version = "master"

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
    Name = "${var.tagname} BUILDER"
  }
}

output "codebuilder_worker_arn" {
  value = aws_codebuild_project.builder_worker.arn
}
