# resource "aws_cloudwatch_metric_alarm" "metrica_fifofull" {
#   alarm_name          = "AlarmeFilaUP"
#   alarm_description   = "lorem ipsum"
#   comparison_operator = "GreaterThanThreshold"
#   evaluation_periods  = 1
#   threshold           = 0
#   #   insufficient_data_actions = []

#   metric_query {
#     id          = "metric"
#     return_data = "true"

#     metric {
#       metric_name = "ApproximateNumberOfMessagesVisible"
#       namespace   = "AWS/SQS"
#       period      = "60"
#       stat        = "Maximum"
#       unit        = "Count"

#       dimensions = {
#         QueueName = var.sqs_name
#       }
#     }
#   }

#   alarm_actions = []
#   ok_actions    = []

# }
# resource "aws_cloudwatch_metric_alarm" "metrica_fifoempty" {
#   alarm_name          = "AlarmeFilaDOWN"
#   alarm_description   = "lorem ipsum"
#   comparison_operator = "LessThanThreshold"
#   evaluation_periods  = 1
#   threshold           = 1
#   #   insufficient_data_actions = []

#   metric_query {
#     id          = "metric"
#     return_data = "true"

#     metric {
#       metric_name = "ApproximateNumberOfMessagesVisible"
#       namespace   = "AWS/SQS"
#       period      = "60"
#       stat        = "Maximum"
#       unit        = "Count"

#       dimensions = {
#         QueueName = var.sqs_name
#       }
#     }
#   }

#   alarm_actions = []
#   ok_actions    = []

# }
