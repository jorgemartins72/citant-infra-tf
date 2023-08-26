resource "aws_cloudwatch_log_group" "this" {
  name = "/ecs/${var.projeto}"
}

output "log_group_arn" {
  value = aws_cloudwatch_log_group.this.arn
}
