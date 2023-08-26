resource "aws_codebuild_project" "this" {
  name         = "${var.tagname}-BUILDER-API-IMAGE"
  service_role = aws_iam_role.BuildProjectRole.arn

  artifacts {
    type = "NO_ARTIFACTS"
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

  source_version = "refs/heads/master"

  source {
    type            = "CODECOMMIT"
    location        = var.repositorio_url
    git_clone_depth = 1
    git_submodules_config {
      fetch_submodules = false
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
    Name = "${var.tagname} BUILDER"
  }
}

resource "aws_iam_role" "BuildProjectRole" {
  name = "${var.tagname}-CodeBuilderRole"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "BuildProjectRolePolicy" {
  name = "${var.tagname}-CodeBuilderRolePolicy"
  role = aws_iam_role.BuildProjectRole.name

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
      {
        "Effect": "Allow",
        "Resource": ["*"],
        "Action": [
          "logs:*"
        ]
      },
      {
        "Effect": "Allow",
        "Resource": [
          "arn:aws:s3:::codepipeline-us-east-1-*"
        ],
        "Action": [
          "s3:PutObject",
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:GetBucketAcl",
          "s3:GetBucketLocation"
        ]
      },
      {
        "Effect": "Allow",
        "Resource": [
          "${var.repositorio_arn}"
        ],
        "Action": [
          "codecommit:GitPull"
        ]
      },
      {
        "Effect": "Allow",
        "Action": [
          "codebuild:CreateReportGroup",
          "codebuild:CreateReport",
          "codebuild:UpdateReport",
          "codebuild:BatchPutTestCases",
          "codebuild:BatchPutCodeCoverages"
        ],
        "Resource": [
          "arn:aws:codebuild:us-east-1:532911710482:report-group/${var.tagname}-BUILDER-API-IMAGE-*"
        ]
      },
      {
        "Effect": "Allow",
        "Action": [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:GetRepositoryPolicy",
          "ecr:DescribeRepositories",
          "ecr:ListImages",
          "ecr:DescribeImages",
          "ecr:BatchGetImage",
          "ecr:GetLifecyclePolicy",
          "ecr:GetLifecyclePolicyPreview",
          "ecr:ListTagsForResource",
          "ecr:DescribeImageScanFindings",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload",
          "ecr:PutImage"
        ],
        "Resource": "*"
      },
      {
        "Effect": "Allow",
        "Action": [
          "ec2:CreateNetworkInterfacePermission"
        ],
        "Resource": [
          "*"
        ]
      },
      {
        "Effect": "Allow",
        "Action": [
          "s3:*"
        ],
        "Resource": [
          "*"
        ]
      },
      {
        "Effect": "Allow",
        "Action": [
          "ecs:*"
        ],
        "Resource": "*"
      },
      {
        "Effect": "Allow",
        "Action": [
          "ssm:DescribeParameters"
        ],
        "Resource": "*"
      },
      {
        "Effect": "Allow",
        "Action": [
            "ssm:GetParameters"
        ],
        "Resource": "*"
      },
      {
        "Effect":"Allow",
        "Action":[
          "kms:Decrypt"
        ],
        "Resource":[
          "*"
        ]
    }
  ]
}
POLICY
}

output "codebuilder_arn" {
  value = aws_codebuild_project.this.arn
}
