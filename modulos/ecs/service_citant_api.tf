resource "aws_ecs_service" "ecs_service" {
  name            = "${var.tagname}-Service"
  task_definition = aws_ecs_task_definition.this.arn
  desired_count   = 1
  cluster         = aws_ecs_cluster.this.id
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [for s in var.subnets.*.id : format("%s", s)]
    security_groups  = [var.security_group_id]
    assign_public_ip = true
  }

  load_balancer {
    container_name   = "${var.container_name}"
    container_port   = 5000
    target_group_arn = aws_alb_target_group.ecs_default_target_group.arn
  }

}

# output "service" {
#   value = aws_ecs_service.ecs_service
# }
