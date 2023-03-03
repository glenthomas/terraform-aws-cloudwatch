variable "queue_name" {
  type = string
}

variable "deadletter_queue_name" {
  type = string
}

variable "message_age_threshold" {
  type    = number
  default = 900
}

variable "message_age_period" {
  type    = number
  default = 60
}

variable "message_age_number_of_periods" {
  type    = number
  default = 1
}

variable "alarm_actions" {
  type = list(string)
}

variable "alarm_actions_enabled" {
  type    = bool
  default = true
}

variable "tags" {
  type    = map(string)
  default = {}
}

resource "aws_cloudwatch_metric_alarm" "sqs_queue_message_age" {
  tags                      = var.tags
  alarm_name                = "${var.queue_name} SQS queue maximum message age"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = var.message_age_number_of_periods
  metric_name               = "ApproximateAgeOfOldestMessage"
  namespace                 = "AWS/SQS"
  period                    = var.message_age_period
  statistic                 = "Maximum"
  threshold                 = var.message_age_threshold
  alarm_description         = "Messages are not being consumed from the queue."
  alarm_actions             = var.alarm_actions
  actions_enabled           = var.alarm_actions_enabled
  insufficient_data_actions = var.alarm_actions
  ok_actions                = var.alarm_actions
  dimensions = {
    QueueName = var.queue_name
  }
}

resource "aws_cloudwatch_metric_alarm" "sqs_deadletter_queue_message_count" {
  tags                      = var.tags
  alarm_name                = "${var.deadletter_queue_name} SQS messages in the dead letter queue."
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = 1
  metric_name               = "ApproximateNumberOfMessagesVisible"
  namespace                 = "AWS/SQS"
  period                    = "60"
  statistic                 = "Sum"
  threshold                 = "1"
  alarm_description         = "There are messages in the dead letter queue."
  alarm_actions             = var.alarm_actions
  actions_enabled           = var.alarm_actions_enabled
  insufficient_data_actions = [] # infrequently used queues frequently stop logging this metric.
  ok_actions                = var.alarm_actions
  treat_missing_data        = "ignore"
  dimensions = {
    QueueName = var.deadletter_queue_name
  }
}
