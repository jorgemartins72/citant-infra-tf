resource "aws_cloudwatch_log_group" "log_group_api" {
  name = "/ecs/${var.projeto}-api"
}

resource "aws_ecs_task_definition" "taskdefinition_api" {
  family                   = "${var.projeto}-api-taskdefinition"
  cpu                      = 512
  memory                   = 1024
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
  execution_role_arn    = aws_iam_role.ecs_task_execution_role_api.arn
  task_role_arn         = aws_iam_role.ecs_task_role_api.arn
  container_definitions = <<TASK_DEFINITION
[
  {
    "name": "${var.projeto}-api-container",
    "image": "${aws_ecr_repository.ecr_api.repository_url}",
    "essential": true,
    "portMappings": [
      {
        "containerPort": 5000,
        "protocol": "tcp"
      }
    ],
    "environment": null,
    "environmentFiles": [],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "/ecs/${var.projeto}-api",
        "awslogs-region": "us-east-1",
        "awslogs-stream-prefix": "ecs"
      }
    }
  }
]
TASK_DEFINITION
}

resource "aws_iam_role" "ecs_task_execution_role_api" {
  name = "${var.tagname}-TaskExecutionRole-API"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": ["ecs.amazonaws.com", "ecs-tasks.amazonaws.com"]
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecs-task-execution-role-policy-attachment-api" {
  role       = aws_iam_role.ecs_task_execution_role_api.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "log_exec-api" {
  role       = aws_iam_role.ecs_task_execution_role_api.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}

resource "aws_iam_role" "ecs_task_role_api" {
  name = "${var.tagname}-TaskRole-API"

  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "ecs-tasks.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "task_s3_api" {
  role       = aws_iam_role.ecs_task_role_api.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role_policy_attachment" "log_task_api" {
  role       = aws_iam_role.ecs_task_role_api.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}

# output "taskdefinition" {
#   value = aws_ecs_task_definition.taskdefinition_api
# }
