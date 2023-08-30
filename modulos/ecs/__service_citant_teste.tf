# resource "aws_ecs_service" "ecs_service-teste" {
#   name            = "${var.tagname}-Service-TESTE"
# #   task_definition = aws_ecs_task_definition.testetd.arn
#   desired_count   = 1
#   cluster         = aws_ecs_cluster.this.id
#   launch_type     = "FARGATE"

#   depends_on = [ aws_ecs_task_definition.testetd ]

#   deployment_controller {
#     type = "EXTERNAL"
#   }

# #   network_configuration {
# #     subnets          = [for s in var.subnets.*.id : format("%s", s)]
# #     security_groups  = [var.security_group_id]
# #     assign_public_ip = true
# #   }

#   #   load_balancer {
#   #     container_name   = "${var.tagname}_Container"
#   #     container_port   = 5000
#   #     target_group_arn = aws_alb_target_group.ecs_default_target_group.arn
#   #   }

# }

# # output "service" {
# #   value = aws_ecs_service.ecs_service
# # }
