variable "rest_api_name" {
  type = string
}

variable "request_latency_p95_threshold" {
  type    = number
  default = 1500
}

variable "request_latency_p95_period" {
  type    = number
  default = 60
}

variable "request_latency_p95_number_of_periods" {
  type    = number
  default = 5
}

variable "bad_request_rate_threshold" {
  type    = number
  default = 5
}

variable "bad_request_rate_period" {
  type    = number
  default = 60
}

variable "bad_request_rate_number_of_periods" {
  type    = number
  default = 1
}

variable "internal_error_rate_threshold" {
  type    = number
  default = 1
}

variable "internal_error_rate_period" {
  type    = number
  default = 60
}

variable "internal_error_rate_number_of_periods" {
  type    = number
  default = 2
}

variable "routes" {
  type = list(object({
    resource                              = string
    stage                                 = string
    method                                = string
    latency_p95_threshold                 = number
    latency_p95_period                    = number
    latency_p95_number_of_periods         = number
    bad_request_rate_threshold            = number
    bad_request_rate_period               = number
    bad_request_rate_number_of_periods    = number
    internal_error_rate_threshold         = number
    internal_error_rate_period            = number
    internal_error_rate_number_of_periods = number
  }))
  default = []
}

locals {
  route_maps = { for route in var.routes : "${route.method} ${route.resource}" => route }
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

resource "aws_cloudwatch_metric_alarm" "api_gateway_p95_latency" {
  alarm_name          = "${var.rest_api_name} API gateway P95 latency"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.request_latency_p95_number_of_periods
  metric_name         = "Latency"
  namespace           = "AWS/ApiGateway"
  period              = var.request_latency_p95_period
  extended_statistic  = "p95.0"
  threshold           = var.request_latency_p95_threshold
  alarm_description   = "API gateway p95 latency is above ${var.request_latency_p95_threshold} milliseconds for ${var.request_latency_p95_number_of_periods} periods"
  alarm_actions       = var.alarm_actions
  ok_actions          = var.alarm_actions
  actions_enabled     = var.alarm_actions_enabled
  treat_missing_data  = "ignore"
  tags                = var.tags
  dimensions          = { ApiName = var.rest_api_name }
}

resource "aws_cloudwatch_metric_alarm" "api_gateway_4xx_rate" {
  alarm_name          = "${var.rest_api_name} API gateway 4xx rate"
  comparison_operator = "GreaterThanThreshold"
  period              = var.bad_request_rate_period
  evaluation_periods  = var.bad_request_rate_number_of_periods
  metric_name         = "4XXError"
  namespace           = "AWS/ApiGateway"
  statistic           = "Average" # The Average statistic represents the 4XXError error rate; the total count of the 4XXError errors divided by the total number of requests during the period.
  threshold           = var.bad_request_rate_threshold / 100
  alarm_description   = "API gateway 4xx rate has exceeded threshold"
  alarm_actions       = var.alarm_actions
  ok_actions          = var.alarm_actions
  treat_missing_data  = "ignore"
  tags                = var.tags
  actions_enabled     = var.alarm_actions_enabled
  dimensions          = { ApiName = var.rest_api_name }
}

resource "aws_cloudwatch_metric_alarm" "api_gateway_5xx_rate" {
  alarm_name          = "${var.rest_api_name} API gateway 5xx rate"
  comparison_operator = "GreaterThanThreshold"
  period              = var.internal_error_rate_period
  evaluation_periods  = var.internal_error_rate_number_of_periods
  metric_name         = "5XXError"
  namespace           = "AWS/ApiGateway"
  statistic           = "Average" # The Average statistic represents the 5XXError error rate; the total count of the 4XXError errors divided by the total number of requests during the period.
  threshold           = var.internal_error_rate_threshold / 100
  alarm_description   = "API gateway 5xx rate has exceeded threshold"
  alarm_actions       = var.alarm_actions
  ok_actions          = var.alarm_actions
  actions_enabled     = var.alarm_actions_enabled
  treat_missing_data  = "ignore"
  tags                = var.tags
  dimensions          = { ApiName = var.rest_api_name }
}

resource "aws_cloudwatch_metric_alarm" "api_gateway_route_p95_latency" {
  for_each            = local.route_maps
  alarm_name          = "${var.rest_api_name} ${each.key} P95 latency"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = each.value.latency_p95_number_of_periods
  metric_name         = "Latency"
  namespace           = "AWS/ApiGateway"
  period              = each.value.latency_p95_period
  extended_statistic  = "p95.0"
  threshold           = each.value.latency_p95_threshold
  alarm_description   = "API gateway p95 latency is above threshold"
  alarm_actions       = var.alarm_actions
  ok_actions          = var.alarm_actions
  actions_enabled     = var.alarm_actions_enabled
  treat_missing_data  = "ignore"
  tags                = var.tags
  dimensions = {
    ApiName  = var.rest_api_name
    Method   = each.value.method
    Resource = each.value.resource
    Stage    = each.value.stage
  }
}

resource "aws_cloudwatch_metric_alarm" "api_gateway_route_4xx_rate" {
  for_each            = local.route_maps
  alarm_name          = "${var.rest_api_name} ${each.key} 4xx rate"
  comparison_operator = "GreaterThanThreshold"
  period              = each.value.bad_request_rate_period
  evaluation_periods  = each.value.bad_request_rate_number_of_periods
  metric_name         = "4XXError"
  namespace           = "AWS/ApiGateway"
  statistic           = "Average" # The Average statistic represents the 4XXError error rate, namely, the total count of the 4XXError errors divided by the total number of requests during the period.
  threshold           = each.value.bad_request_rate_threshold / 100
  alarm_description   = "API gateway 4xx rate has exceeded threshold"
  alarm_actions       = var.alarm_actions
  ok_actions          = var.alarm_actions
  treat_missing_data  = "ignore"
  tags                = var.tags
  actions_enabled     = var.alarm_actions_enabled
  dimensions = {
    ApiName  = var.rest_api_name
    Method   = each.value.method
    Resource = each.value.resource
    Stage    = each.value.stage
  }
}

resource "aws_cloudwatch_metric_alarm" "api_gateway_route_5xx_rate" {
  for_each            = local.route_maps
  alarm_name          = "${var.rest_api_name} ${each.key} 5xx rate"
  comparison_operator = "GreaterThanThreshold"
  period              = each.value.internal_error_rate_period
  evaluation_periods  = each.value.internal_error_rate_number_of_periods
  metric_name         = "5XXError"
  namespace           = "AWS/ApiGateway"
  statistic           = "Average" # The Average statistic represents the 5XXError error rate, namely, the total count of the 4XXError errors divided by the total number of requests during the period.
  threshold           = each.value.internal_error_rate_threshold / 100
  alarm_description   = "API gateway 5xx rate has exceeded threshold"
  alarm_actions       = var.alarm_actions
  ok_actions          = var.alarm_actions
  actions_enabled     = var.alarm_actions_enabled
  treat_missing_data  = "ignore"
  tags                = var.tags
  dimensions = {
    ApiName  = var.rest_api_name
    Method   = each.value.method
    Resource = each.value.resource
    Stage    = each.value.stage
  }
}
