variable "lambda_function_name" {
  type = string
  description = "The name of your lambda function."
}

variable "lambda_log_group_name" {
  type = string
  description = "The name of your lambda CloudWatch log group"
}

variable "create_max_memory_metric" {
  type = bool
  default = true
  description = "Create LambdaMaxMemoryUsed metric for measuring invocation memory usage."
}

variable "create_cold_duration_metric" {
  type = bool
  default = true
  description = "Create LambdaColdStartDuration metric for measuring cold start invocation duration."
}

variable "create_cold_count_metric" {
  type = bool
  default = true
  description = "Create LambdaColdStartCount metric for measuring cold start invocations."
}

variable "create_init_duration_metric" {
  type = bool
  default = false
  description = "Create LambdaInitDuration metric for measuring pre-invocation lambda runtime initialization duration."
}

variable "create_billed_duration_metric" {
  type = bool
  default = false
  description = "Create LambdaBilledDuration metric for measuring billed durations."
}

# During the init phase, Lambda creates or unfreezes an execution environment with the configured resources,
# downloads the code for the function and all layers, initializes any extensions, initializes the runtime, 
# and then runs the function’s initialization code (the code outside the main handler). The Init phase 
# happens either during the first invocation, or in advance of function invocations if you have enabled 
# provisioned concurrency.
# The Init phase is split into three sub-phases: Extension init, Runtime init, and Function init. 
# These sub-phases ensure that all extensions and the runtime complete their setup tasks before the function
# code runs. The Init phase is limited to 10 seconds. If all three tasks do not complete within 10 seconds, 
# Lambda retries the Init phase at the time of the first function invocation.
resource "aws_cloudwatch_log_metric_filter" "lambda_init_duration" {
  name           = "${var.lambda_function_name}-lambda-init-duration"
  for_each       = var.create_init_duration_metric ? { deploy = "yes" } : {}
  pattern        = "[report_label=\"REPORT\", request_id_label, request_id_value, duration_label, duration_value, duration_unit, billed_duration_label1, bill_duration_label2, billed_duration_value, billed_duration_unit, memory_size_label1, memory_size_label2, memory_size_value, memory_size_unit, max_memory_used_label1, max_memory_used_label2, max_memory_used_label3, max_memory_used_value, max_memory_used_unit, init_duration_label1, init_duration_label2, init_duration_value, init_duration_unit]"
  log_group_name = var.lambda_log_group_name
  metric_transformation {
    name      = "LambdaInitDuration"
    namespace = var.lambda_function_name
    value     = "$init_duration_value"
  }
}

resource "aws_cloudwatch_log_metric_filter" "lambda_billed_duration" {
  name           = "${var.lambda_function_name}-lambda-billed-duration"
  for_each       = var.create_billed_duration_metric ? { deploy = "yes" } : {}
  pattern        = "[report_label=\"REPORT\", request_id_label, request_id_value, duration_label, duration_value, duration_unit, billed_duration_label1, bill_duration_label2, billed_duration_value, billed_duration_unit, memory_size_label1, memory_size_label2, memory_size_value, memory_size_unit, max_memory_used_label1, max_memory_used_label2, max_memory_used_label3, max_memory_used_value, max_memory_used_unit]"
  log_group_name = var.lambda_log_group_name
  metric_transformation {
    name      = "LambdaBilledDuration"
    namespace = var.lambda_function_name
    value     = "$billed_duration_value"
  }
}

resource "aws_cloudwatch_log_metric_filter" "lambda_cold_start_duration" {
  name           = "${var.lambda_function_name}-lambda-cold-start-duration"
  for_each       = var.create_cold_duration_metric ? { deploy = "yes" } : {}
  pattern        = "[report_label=\"REPORT\", request_id_label, request_id_value, duration_label, duration_value, duration_unit, billed_duration_label1, bill_duration_label2, billed_duration_value, billed_duration_unit, memory_size_label1, memory_size_label2, memory_size_value, memory_size_unit, max_memory_used_label1, max_memory_used_label2, max_memory_used_label3, max_memory_used_value, max_memory_used_unit, init_duration_label1, init_duration_label2, init_duration_value, init_duration_unit]"
  log_group_name = var.lambda_log_group_name
  metric_transformation {
    name      = "LambdaColdStartDuration"
    namespace = var.lambda_function_name
    value     = "$duration_value"
  }
}

resource "aws_cloudwatch_log_metric_filter" "lambda_cold_start_count" {
  name           = "${var.lambda_function_name}-lambda-cold-start-count"
  for_each       = var.create_cold_count_metric ? { deploy = "yes" } : {}
  pattern        = "[report_label=\"REPORT\", request_id_label, request_id_value, duration_label, duration_value, duration_unit, billed_duration_label1, bill_duration_label2, billed_duration_value, billed_duration_unit, memory_size_label1, memory_size_label2, memory_size_value, memory_size_unit, max_memory_used_label1, max_memory_used_label2, max_memory_used_label3, max_memory_used_value, max_memory_used_unit, init_duration_label1, init_duration_label2, init_duration_value, init_duration_unit]"
  log_group_name = var.lambda_log_group_name
  metric_transformation {
    name      = "LambdaColdStartCount"
    namespace = var.lambda_function_name
    value     = 1
  }
}

resource "aws_cloudwatch_log_metric_filter" "lambda_max_memory_used" {
  name           = "${var.lambda_function_name}-lambda-max-memory-used"
  for_each       = var.create_max_memory_metric ? { deploy = "yes" } : {}
  pattern        = "[report_label=\"REPORT\", request_id_label, request_id_value, duration_label, duration_value, duration_unit, billed_duration_label1, bill_duration_label2, billed_duration_value, billed_duration_unit, memory_size_label1, memory_size_label2, memory_size_value, memory_size_unit, max_memory_used_label1, max_memory_used_label2, max_memory_used_label3, max_memory_used_value, max_memory_used_unit]"
  log_group_name = var.lambda_log_group_name
  metric_transformation {
    name      = "LambdaMaxMemoryUsed"
    namespace = var.lambda_function_name
    value     = "$max_memory_used_value"
  }
}
