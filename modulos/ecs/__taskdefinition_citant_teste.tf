# resource "aws_ecs_task_definition" "testetd" {
#   family                   = "taskdefinition_teste"
#   cpu                      = 512
#   memory                   = 1024
#   requires_compatibilities = ["FARGATE"]
#   network_mode             = "awsvpc"
#   runtime_platform {
#     operating_system_family = "LINUX"
#     cpu_architecture        = "X86_64"
#   }
#   execution_role_arn    = aws_iam_role.ecs_task_execution_role.arn
#   task_role_arn         = aws_iam_role.ecs_task_role.arn
#   container_definitions = <<TASK_DEFINITION
# [
#   {
#     "name": "container_teste",
#     "image": "${var.image_url}",
#     "essential": true,
#     "portMappings": [
#       {
#         "containerPort": 5000,
#         "protocol": "tcp"
#       }
#     ],
#     "environment": null,
#     "environmentFiles": [],
#     "logConfiguration": {
#       "logDriver": "awslogs",
#       "options": {
#         "awslogs-group": "/ecs/${var.projeto}-teste",
#         "awslogs-region": "us-east-1",
#         "awslogs-stream-prefix": "ecs"
#       }
#     }
#   }
# ]
# TASK_DEFINITION
# }

# resource "aws_iam_role" "ecs_task_execution_role-teste" {
#   name = "${var.tagname}-TaskExecutionRole-TESTE"

#   assume_role_policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Action": "sts:AssumeRole",
#       "Principal": {
#         "Service": ["ecs.amazonaws.com", "ecs-tasks.amazonaws.com"]
#       },
#       "Effect": "Allow",
#       "Sid": ""
#     }
#   ]
# }
# EOF
# }

# resource "aws_iam_role_policy_attachment" "ecs-task-execution-role-policy-attachment-teste" {
#   role       = aws_iam_role.ecs_task_execution_role.name
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
# }

# resource "aws_iam_role_policy_attachment" "log_exec-teste" {
#   role       = aws_iam_role.ecs_task_execution_role.name
#   policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
# }

# resource "aws_iam_role" "ecs_task_role-teste" {
#   name = "${var.tagname}-TaskRole-TESTE"

#   assume_role_policy = <<EOF
# {
#  "Version": "2012-10-17",
#  "Statement": [
#    {
#      "Action": "sts:AssumeRole",
#      "Principal": {
#        "Service": "ecs-tasks.amazonaws.com"
#      },
#      "Effect": "Allow",
#      "Sid": ""
#    }
#  ]
# }
# EOF
# }

# resource "aws_iam_role_policy_attachment" "task_s3-teste" {
#   role       = aws_iam_role.ecs_task_role.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
# }

# resource "aws_iam_role_policy_attachment" "log_task-teste" {
#   role       = aws_iam_role.ecs_task_role.name
#   policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
# }

# output "taskdefinition-teste" {
#   value = aws_ecs_task_definition.testetd
# }
