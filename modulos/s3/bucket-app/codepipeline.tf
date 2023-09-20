resource "aws_codepipeline" "codepipeline_app" {
  name     = "${var.projeto}-website-pipeline"
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
}
