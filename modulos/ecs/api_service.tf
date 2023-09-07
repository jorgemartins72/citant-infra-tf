resource "aws_ecs_service" "ecs_service_api" {
  name            = "${var.tagname}-API-Service"
  task_definition = aws_ecs_task_definition.taskdefinition_api.arn
  desired_count   = 1
  cluster         = aws_ecs_cluster.this.id
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [for s in var.subnets.*.id : format("%s", s)]
    security_groups  = [var.security_group_id]
    assign_public_ip = true
  }

  load_balancer {
    container_name   = "${var.projeto}-api-container"
    container_port   = 5000
    target_group_arn = aws_alb_target_group.ecs_default_target_group.arn
  }
}

resource "aws_appautoscaling_target" "target_api" {
  max_capacity       = 6
  min_capacity       = 1
  resource_id        = "service/${aws_ecs_cluster.this.name}/${aws_ecs_service.ecs_service_api.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "politica_api_scale_up" {
  depends_on         = [aws_appautoscaling_target.target_api]
  name               = "${var.tagname}-API-ScaleUP"
  policy_type        = "StepScaling"
  resource_id        = aws_appautoscaling_target.target_api.resource_id
  scalable_dimension = aws_appautoscaling_target.target_api.scalable_dimension
  service_namespace  = aws_appautoscaling_target.target_api.service_namespace

  step_scaling_policy_configuration {
    cooldown                = 60
    adjustment_type         = "ChangeInCapacity"
    metric_aggregation_type = "Maximum"
    # min_adjustment_magnitude = 0

    step_adjustment {
      scaling_adjustment          = 1
      metric_interval_lower_bound = 1
      metric_interval_upper_bound = ""
    }
  }
}

resource "aws_appautoscaling_policy" "politica_api_scale_down" {
  depends_on         = [aws_appautoscaling_target.target_api]
  name               = "${var.tagname}-API-ScaleDOWN"
  policy_type        = "StepScaling"
  resource_id        = aws_appautoscaling_target.target_api.resource_id
  scalable_dimension = aws_appautoscaling_target.target_api.scalable_dimension
  service_namespace  = aws_appautoscaling_target.target_api.service_namespace

  step_scaling_policy_configuration {
    cooldown                = 60
    adjustment_type         = "ChangeInCapacity"
    metric_aggregation_type = "Maximum"
    # min_adjustment_magnitude = 0

    step_adjustment {
      scaling_adjustment          = -1
      metric_interval_lower_bound = 1
      metric_interval_upper_bound = ""
    }
  }
}

resource "aws_cloudwatch_metric_alarm" "cpu_up" {
  alarm_name          = "${var.tagname}-API-UP"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  threshold           = 60
  alarm_actions       = ["${aws_appautoscaling_policy.politica_api_scale_up.arn}"]

  metric_query {
    id          = "scaling_up"
    return_data = "true"

    metric {
      metric_name = "CPUUtilization"
      namespace   = "AWS/ECS"
      period      = 60
      stat        = "Maximum"
      unit        = "Percent"

      dimensions = {
        ClusterName = aws_ecs_cluster.this.name
        ServiceName = aws_ecs_service.ecs_service_api.name
      }
    }
  }
}

resource "aws_cloudwatch_metric_alarm" "cpu_down" {
  alarm_name          = "${var.tagname}-API-DOWN"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 1
  threshold           = 60
  alarm_actions       = ["${aws_appautoscaling_policy.politica_api_scale_down.arn}"]

  metric_query {
    id          = "scaling_down"
    return_data = "true"

    metric {
      metric_name = "CPUUtilization"
      namespace   = "AWS/ECS"
      period      = 60
      stat        = "Maximum"
      unit        = "Percent"

      dimensions = {
        ClusterName = aws_ecs_cluster.this.name
        ServiceName = aws_ecs_service.ecs_service_api.name
      }
    }
  }
}

# resource "aws_appautoscaling_policy" "ecs_app_policy_api" {
#   name               = "autoscaling${var.tagname}policy"
#   policy_type        = "TargetTrackingScaling"
#   resource_id        = aws_appautoscaling_target.ecs_app_target_api.resource_id
#   scalable_dimension = aws_appautoscaling_target.ecs_app_target_api.scalable_dimension
#   service_namespace  = aws_appautoscaling_target.ecs_app_target_api.service_namespace

#   target_tracking_scaling_policy_configuration {
#     predefined_metric_specification {
#       predefined_metric_type = "ECSServiceAverageCPUUtilization"
#     }

#     target_value       = 40.0
#     scale_in_cooldown  = 60
#     scale_out_cooldown = 60
#   }
# }

# output "ecs_service_api_name" {
#   value = aws_ecs_service.ecs_service_api.name
# }
