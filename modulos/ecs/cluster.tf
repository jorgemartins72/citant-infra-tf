resource "aws_service_discovery_http_namespace" "this" {
  name        = "${var.projeto}-service-discovery-namespace"
  description = ""
}

resource "aws_ecs_cluster" "this" {
  name = "${var.tagname}-CLUSTER"
}

resource "aws_iam_role" "ecs_cluster_role" {
  name = "${var.tagname}-ClusterRole"

  assume_role_policy = <<EOF
{
"Version": "2012-10-17",
"Statement": [
 {
   "Effect": "Allow",
   "Principal": {
     "Service": ["ecs.amazonaws.com", "ec2.amazonaws.com", "application-autoscaling.amazonaws.com"]
   },
   "Action": "sts:AssumeRole"
  }
  ]
 }
EOF
}

resource "aws_iam_role_policy" "ecs_cluster_policy" {
  name = "${var.tagname}-ClusterRolePolicy"
  role = aws_iam_role.ecs_cluster_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ecs:*",
        "ec2:*",
        "elasticloadbalancing:*",
        "ecr:*",
        "dynamodb:*",
        "cloudwatch:*",
        "s3:*",
        "rds:*",
        "sqs:*",
        "sns:*",
        "logs:*",
        "ssm:*"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

output "cluster_name" {
  value = aws_ecs_cluster.this.name
}

