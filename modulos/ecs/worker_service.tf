resource "aws_ecs_service" "ecs_service_worker" {
  name            = "${var.tagname}-WORKER-Service"
  task_definition = aws_ecs_task_definition.worker.arn
  desired_count   = 0
  cluster         = aws_ecs_cluster.this.id
  launch_type     = "FARGATE"

  depends_on = [aws_ecs_task_definition.worker]

  network_configuration {
    subnets          = [for s in var.subnets.*.id : format("%s", s)]
    security_groups  = [var.security_group_id]
    assign_public_ip = true
  }
}

resource "aws_appautoscaling_target" "target_worker" {
  max_capacity       = 1
  min_capacity       = 0
  resource_id        = "service/${aws_ecs_cluster.this.name}/${aws_ecs_service.ecs_service_worker.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "politica_worker_scale_up" {
  depends_on         = [aws_appautoscaling_target.target_worker]
  name               = "${var.tagname}-WORKER-ScaleUP"
  policy_type        = "StepScaling"
  resource_id        = aws_appautoscaling_target.target_worker.resource_id
  scalable_dimension = aws_appautoscaling_target.target_worker.scalable_dimension
  service_namespace  = aws_appautoscaling_target.target_worker.service_namespace

  step_scaling_policy_configuration {
    cooldown                 = 60
    adjustment_type          = "ChangeInCapacity"
    metric_aggregation_type  = "Maximum"
    min_adjustment_magnitude = 0

    step_adjustment {
      scaling_adjustment          = 1
      metric_interval_lower_bound = 0
      metric_interval_upper_bound = ""
    }
  }
}

resource "aws_appautoscaling_policy" "politica_worker_scale_down" {
  depends_on         = [aws_appautoscaling_target.target_worker]
  name               = "${var.tagname}-WORKER-ScaleDOWN"
  policy_type        = "StepScaling"
  resource_id        = aws_appautoscaling_target.target_worker.resource_id
  scalable_dimension = aws_appautoscaling_target.target_worker.scalable_dimension
  service_namespace  = aws_appautoscaling_target.target_worker.service_namespace

  step_scaling_policy_configuration {
    cooldown                 = 60
    adjustment_type          = "ChangeInCapacity"
    metric_aggregation_type  = "Maximum"
    min_adjustment_magnitude = 0

    step_adjustment {
      scaling_adjustment          = -1
      metric_interval_lower_bound = ""
      metric_interval_upper_bound = 0
    }
  }
}

resource "aws_cloudwatch_metric_alarm" "queue_up" {
  alarm_name          = "${var.tagname}-WORKER-UP"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  threshold           = 0
  alarm_actions       = ["${aws_appautoscaling_policy.politica_worker_scale_up.arn}"]

  metric_query {
    id          = "scaling_up"
    return_data = "true"

    metric {
      metric_name = "ApproximateNumberOfMessagesVisible"
      namespace   = "AWS/SQS"
      period      = 60
      stat        = "Maximum"
      unit        = "Count"

      dimensions = {
        QueueName = var.sqs_name
      }
    }
  }
}

resource "aws_cloudwatch_metric_alarm" "queue_down" {
  alarm_name          = "${var.tagname}-WORKER-DOWN"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 1
  threshold           = 0.9
  alarm_actions       = ["${aws_appautoscaling_policy.politica_worker_scale_down.arn}"]

  metric_query {
    id          = "visible"
    return_data = "true"

    metric {
      metric_name = "ApproximateNumberOfMessagesVisible"
      namespace   = "AWS/SQS"
      period      = 60
      stat        = "Maximum"
      unit        = "Count"

      dimensions = {
        QueueName = var.sqs_name
      }
    }
  }
}

