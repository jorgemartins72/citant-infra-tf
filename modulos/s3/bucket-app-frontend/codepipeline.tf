resource "aws_codepipeline" "codepipeline_app" {
  name     = "${var.projeto}-app-pipeline"
  role_arn = aws_iam_role.codepipeline_role_app.arn

  artifact_store {
    location = aws_s3_bucket.bucket_codepipeline_app.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeCommit"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        RepositoryName = aws_codecommit_repository.codecommit_app.repository_name
        BranchName     = "master"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      version          = "1"

      configuration = {
        ProjectName = aws_codebuild_project.builder_app.name
      }
    }
  }

  #   stage {
  #     name = "Deploy"

  #     action {
  #       name            = "Deploy"
  #       category        = "Deploy"
  #       owner           = "AWS"
  #       provider        = "ECS"
  #       input_artifacts = ["build_output"]
  #       version         = "1"

  #       configuration = {
  #         ClusterName = aws_ecs_cluster.this.name
  #         ServiceName = aws_ecs_service.ecs_service_worker.name
  #         FileName    = "imagedefinitions.json"
  #       }
  #     }
  #   }
}
