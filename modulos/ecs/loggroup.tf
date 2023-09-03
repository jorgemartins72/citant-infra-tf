resource "aws_cloudwatch_log_group" "api" {
  name = "/ecs/${var.projeto}-api"
}
resource "aws_cloudwatch_log_group" "worker" {
  name = "/ecs/${var.projeto}-worker"
}

output "log_group_arn" {
  value = aws_cloudwatch_log_group.api.arn
}
