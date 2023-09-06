
resource "aws_iam_role" "build_role_api" {
  name = "${var.tagname}-API-CodeBuilderRole"

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

resource "aws_iam_role_policy" "build_role_api_policy" {
  name = "${var.tagname}-API-CodeBuilderRolePolicy"
  role = aws_iam_role.build_role_api.name

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
      {
        "Effect": "Allow",
        "Resource": "*",
        "Action": [
          "logs:*"
        ]
      },
      {
        "Effect": "Allow",
        "Resource": [
          "${aws_s3_bucket.bucket_codepipeline_api.arn}",
          "${aws_s3_bucket.bucket_codepipeline_api.arn}/*"
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
          "${aws_codecommit_repository.codecommit_api.arn}"
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
        "Resource": "*"
      },
      {
        "Effect": "Allow",
        "Action": [
          "s3:*"
        ],
        "Resource": "*"
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
        "Resource": "*"
    }
  ]
}
POLICY
}