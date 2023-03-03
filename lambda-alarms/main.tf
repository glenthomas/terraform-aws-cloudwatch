variable "function_name" {
  type = string
}

variable "is_edge_lambda" {
  type    = bool
  default = false
}

variable "error_rate_threshold" {
  type    = number
  default = 1
}

variable "error_rate_period" {
  type    = number
  default = 60
}

variable "error_rate_number_of_periods" {
  type    = number
  default = 3
}

variable "duration_average_threshold" {
  type    = number
  default = 2000
}

variable "duration_average_period" {
  type    = number
  default = 60
}

variable "duration_average_number_of_periods" {
  type    = number
  default = 3
}

variable "duration_p95_threshold" {
  type    = number
  default = 5000
}

variable "duration_p95_period" {
  type    = number
  default = 60
}

variable "duration_p95_number_of_periods" {
  type    = number
  default = 3
}

variable "concurrent_execution_number_of_periods" {
  type    = number
  default = 3
}

variable "concurrent_executions_period" {
  type    = number
  default = 60
}

variable "concurrent_executions_threshold" {
  type    = number
  default = 300
}

variable "alarm_actions" {
  type    = list(string)
  default = []
}

variable "alarm_actions_enabled" {
  type    = bool
  default = true
}

variable "tags" {
  type    = map(string)
  default = {}
}

locals {
  metric_function_name = var.is_edge_lambda ? "us-east-1.${var.function_name}" : var.function_name
}

resource "aws_cloudwatch_metric_alarm" "lambda_error_rate" {
  alarm_name          = "${var.function_name} Lambda error rate"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = var.error_rate_number_of_periods
  threshold           = var.error_rate_threshold
  alarm_description   = "Lambda error rate has exceeded threshold"
  alarm_actions       = var.alarm_actions
  ok_actions          = var.alarm_actions
  treat_missing_data  = "ignore"
  actions_enabled     = var.alarm_actions_enabled
  tags                = var.tags

  metric_query {
    id          = "errorRate"
    expression  = "errorCount/invocationCount*100"
    label       = "Error Rate"
    return_data = "true"
  }

  metric_query {
    id = "invocationCount"
    metric {
      metric_name = "Invocations"
      namespace   = "AWS/Lambda"
      period      = var.error_rate_period
      stat        = "Sum"
      dimensions  = { FunctionName = local.metric_function_name }
    }
  }

  metric_query {
    id = "errorCount"
    metric {
      metric_name = "Errors"
      namespace   = "AWS/Lambda"
      period      = var.error_rate_period
      stat        = "Sum"
      dimensions  = { FunctionName = local.metric_function_name }
    }
  }
}

output "lambda_error_rate_alarm_arn" {
  value = aws_cloudwatch_metric_alarm.lambda_error_rate.arn
}

resource "aws_cloudwatch_metric_alarm" "lambda_average_duration" {
  alarm_name          = "${var.function_name} Lambda average duration"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = var.duration_average_number_of_periods
  metric_name         = "Duration"
  namespace           = "AWS/Lambda"
  period              = var.duration_average_period
  statistic           = "Average"
  threshold           = var.duration_average_threshold
  alarm_description   = "Lambda average execution duration has exceeded acceptable threshold"
  alarm_actions       = var.alarm_actions
  ok_actions          = var.alarm_actions
  actions_enabled     = var.alarm_actions_enabled
  dimensions          = { FunctionName = local.metric_function_name }
  treat_missing_data  = "ignore"
  tags                = var.tags
}

resource "aws_cloudwatch_metric_alarm" "lambda_p95_duration" {
  alarm_name          = "${var.function_name} Lambda P95 duration"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = var.duration_p95_number_of_periods
  metric_name         = "Duration"
  namespace           = "AWS/Lambda"
  period              = var.duration_p95_period
  extended_statistic  = "p95"
  threshold           = var.duration_p95_threshold
  alarm_description   = "Lambda P95 execution duration has exceeded acceptable threshold"
  alarm_actions       = var.alarm_actions
  ok_actions          = var.alarm_actions
  actions_enabled     = var.alarm_actions_enabled
  dimensions          = { FunctionName = local.metric_function_name }
  treat_missing_data  = "ignore"
  tags                = var.tags
}

resource "aws_cloudwatch_metric_alarm" "lambda_concurrent_executions" {
  alarm_name          = "${var.function_name} Lambda Concurrent Executions"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = var.concurrent_execution_number_of_periods
  metric_name         = "ConcurrentExecutions"
  namespace           = "AWS/Lambda"
  period              = var.concurrent_executions_period
  statistic           = "Maximum"
  threshold           = var.concurrent_executions_threshold
  alarm_description   = "High number of concurrent lambda executions"
  alarm_actions       = var.alarm_actions
  ok_actions          = var.alarm_actions
  actions_enabled     = var.alarm_actions_enabled
  dimensions          = { FunctionName = local.metric_function_name }
  treat_missing_data  = "ignore"
  tags                = var.tags
}
