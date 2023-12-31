resource "aws_cloudwatch_log_group" "log_group-worker" {
  name = "/ecs/${var.projeto}-worker"
}

resource "aws_ecs_task_definition" "worker" {
  family                   = "${var.projeto}-worker-taskdefinition"
  cpu                      = 512
  memory                   = 1024
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
  execution_role_arn    = aws_iam_role.ecs_task_execution_role-worker.arn
  task_role_arn         = aws_iam_role.ecs_task_role-worker.arn
  container_definitions = <<TASK_DEFINITION
[
  {
    "name": "${var.projeto}-worker-container",
    "image": "${aws_ecr_repository.ecr_worker.repository_url}",
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
        "awslogs-group": "/ecs/${var.projeto}-worker",
        "awslogs-region": "us-east-1",
        "awslogs-stream-prefix": "ecs"
      }
    }
  }
]
TASK_DEFINITION
}

resource "aws_iam_role" "ecs_task_execution_role-worker" {
  name = "${var.tagname}-TaskExecutionRole-WORKER"

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

resource "aws_iam_role_policy_attachment" "ecs-task-execution-role-policy-attachment-worker" {
  role       = aws_iam_role.ecs_task_execution_role-worker.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "log_exec-worker" {
  role       = aws_iam_role.ecs_task_execution_role-worker.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}

resource "aws_iam_role" "ecs_task_role-worker" {
  name = "${var.tagname}-TaskRole-WORKER"

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

resource "aws_iam_role_policy_attachment" "task_s3-worker" {
  role       = aws_iam_role.ecs_task_role-worker.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role_policy_attachment" "log_task-worker" {
  role       = aws_iam_role.ecs_task_role-worker.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}

# output "worker_taskdefinition" {
#   value = aws_ecs_task_definition.worker
# }
