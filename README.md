# AWS CloudWatch Alarms Terraform Modules

Terraform modules for AWS CloudWatch alarms.

## Modules

The following modules are available

| Module Name          | Purpose                                            |
| -------------------- | -------------------------------------------------- |
| api-gateway-alarms   | CloudWatch alarms for API gateway                  |
| api-gateway-v2-alarms | CloudWatch alarms for API gateway V2              |
| dashboard-widget     | Generate a widget for CloudWatch dashboards        |
| lambda-alarms        | CloudWatch alarms for lambda                       |
| lambda-metrics       | CloudWatch metric filters for lambda               |
| sqs-queue-alarms     | CloudWatch alarms for SQS                          |
| widget-metrics       | Generate metric expressions for CloudWatch widgets |

### api-gateway-alarms

Use this module to create CloudWatch alarms for API gateway V1 (REST APIs).
- P95 request latency
- 4xx response rate
- 5xx response rate

#### Inputs

| Name                                  | Description                                                                                |
| ------------------------------------- | ------------------------------------------------------------------------------------------ |
| rest_api_name                         | The name of your API gateway                                                               |
| request_latency_p95_threshold         | The maximum P95 request latency in milliseconds before triggering the alarm. Default 1500  |
| request_latency_p95_period            | The number of seconds per evaluation period. Default 60                                    |
| request_latency_p95_number_of_periods | The number of periods the P95 request latency threshold must be breached for. Default 5    |
| bad_request_rate_threshold            | The maximum percentage of 4xx responses before triggering the alarm. Default 5             |
| bad_request_rate_period               | The number of seconds per evaluation period. Default 60                                    |
| bad_request_rate_number_of_periods    | The number of periods the 4xx response rate threshold must be breached for. Default 1      |
| internal_error_rate_threshold         | The maximum percentage of 5xx responses before triggering the alarm. Default 1             |
| internal_error_rate_period            | The number of seconds per evaluation period. Default 60                                    |
| internal_error_rate_number_of_periods | The number of periods the 5xx response rate threshold must be breached for. Default 2      |
| routes                                | List of routes for creating alarms-per-route. See [routes variable](source/api-gateway-alarms/main.tf#L50).|
| alarm_actions                         | A list of SNS topic ARNs to send alarm events to                                           |
| alarm_actions_enabled                 | Set to false to silence the alarms. Default true                                           |
| tags                                  | A map of tags to be added to AWS resources                                                 |

#### Outputs

None.

#### Example usage

```hcl
module api_gateway_alarms {
  source                        = "github.com/glenthomas/terraform-aws-cloudwatch//api-gateway-alarms"
  alarm_actions                 = [module.slack_alerts.sns_topic_arn]
  rest_api_name                 = "my-api-gateway"
  bad_request_rate_threshold    = 5
  internal_error_rate_threshold = 1
  request_latency_p95_threshold = 1500
  routes = [
    {
      resource = "/health"
      method = "GET"
      stage = local.stage_name
      latency_p95_threshold = 500
      latency_p95_period = 60
      latency_p95_number_of_periods = 5
      bad_request_rate_threshold = 1
      bad_request_rate_period = 60
      bad_request_rate_number_of_periods = 5
      internal_error_rate_threshold = 1
      internal_error_rate_period = 60
      internal_error_rate_number_of_periods = 3
    },
    {
      resource = "/graphql"
      method = "POST"
      stage = local.stage_name
      latency_p95_threshold = 2000
      latency_p95_period = 60
      latency_p95_number_of_periods = 5
      bad_request_rate_threshold = 1
      bad_request_rate_period = 60
      bad_request_rate_number_of_periods = 5
      internal_error_rate_threshold = 1
      internal_error_rate_period = 60
      internal_error_rate_number_of_periods = 3
    }
  ]
}
```

### api-gateway-v2-alarms

Use this module to create CloudWatch alarms for API gateway V2 (HTTP APIs).
- P95 request latency
- 4xx response rate
- 5xx response rate

#### Inputs

| Name                                  | Description                                                                                |
| ------------------------------------- | ------------------------------------------------------------------------------------------ |
| rest_api_id                           | The ID of your API gateway                                                                 |
| rest_api_name                         | The name of your API gateway                                                               |
| request_latency_p95_threshold         | The maximum P95 request latency in milliseconds before triggering the alarm. Default 1500  |
| request_latency_p95_period            | The number of seconds per evaluation period. Default 60                                    |
| request_latency_p95_number_of_periods | The number of periods the P95 request latency threshold must be breached for. Default 5    |
| bad_request_rate_threshold            | The maximum percentage of 4xx responses before triggering the alarm. Default 5             |
| bad_request_rate_period               | The number of seconds per evaluation period. Default 60                                    |
| bad_request_rate_number_of_periods    | The number of periods the 4xx response rate threshold must be breached for. Default 1      |
| internal_error_rate_threshold         | The maximum percentage of 5xx responses before triggering the alarm. Default 1             |
| internal_error_rate_period            | The number of seconds per evaluation period. Default 60                                    |
| internal_error_rate_number_of_periods | The number of periods the 5xx response rate threshold must be breached for. Default 2      |
| alarm_actions                         | A list of SNS topic ARNs to send alarm events to                                           |
| alarm_actions_enabled                 | Set to false to silence the alarms. Default true                                           |
| tags                                  | A map of tags to be added to AWS resources                                                 |

#### Outputs

None.

#### Example usage

```hcl
module "api_gateway_alarms" {
  source                        = "github.com/glenthomas/terraform-aws-cloudwatch//api-gateway-v2-alarms"
  alarm_actions                 = [module.slack_alerts.sns_topic_arn]
  rest_api_name                 = aws_apigatewayv2_api.example.name
  rest_api_id                   = aws_apigatewayv2_api.example.id
  bad_request_rate_threshold    = 5
  internal_error_rate_threshold = 1
  request_latency_p95_threshold = 1500
}
```

### dashboard-widget

Use this module to create a widget to place on a CloudWatch dashboard.

#### Inputs

| Name                       | Description                                                                      |
| -------------------------- | -------------------------------------------------------------------------------- |
| title                      | A title to be displayed on the widget                                            |
| metrics                    | An array of arrays specifying metrics to be displayed on the widget              |
| region                     | The AWS region to display metric data for                                        |
| position (optional)        | A map with x and y properties that position the widget on the dashboard          |
| size (optional)            | A map with width and height properties that position the widget on the dashboard |
| legend_position (optional) | Position of legend. "bottom"/"right"/"hidden". Default bottom                    |
| show_labels (optional)     | Show or hide labels. Default true.                                               |

#### Outputs

| Name                  | Description                                                       |
| --------------------- | ----------------------------------------------------------------- |
| widget                | The resulting widget object to be added to a CloudWatch dashboard |

#### Example usage

```hcl
module my_widget {
  source    = "github.com/glenthomas/terraform-aws-cloudwatch//dashboard-widget"
  title     = "HTTP requests"
  region    = "eu-west-1"
  metrics = [
    module.metrics.http_operation_request_count_search,
  ]
}
```

### lambda-alarms

Use this module to create CloudWatch alarms for lambda functions.
- Error count
- Duration count
- Concurrent Executions count

#### Inputs

| Name                                  | Description                                                                               |
| ------------------------------------- | ----------------------------------------------------------------------------------------- |
| function_name                         | The name of your lambda function                                                          |
| is_edge_lambda                        | True if your lambda function is Lambda@Edge (CloudFront)                                  |
| error_rate_threshold                  | The maximum percentage of errors before triggering the alarm. Default 1                   |
| error_rate_period                     | The number of seconds per evaluation period. Default 60                                   |
| error_rate_number_of_periods          | The number of periods the error rate threshold must be breached for. Default 3            |
| duration_average_threshold            | The average execution duration in milliseconds before triggering the alarm. Default 2000  |
| duration_average_period               | The number of seconds per evaluation period. Default 60                                   |
| duration_average_number_of_periods    | The number of periods the average duration threshold must be breached for. Default 3      |
| duration_p95_threshold                | The p95 execution duration in milliseconds before triggering the alarm. Default 5000      |
| duration_p95_period                   | The number of seconds per evaluation period. Default 60                                   |
| duration_p95_number_of_periods        | The number of periods the p95 duration threshold must be breached for. Default 3          |
| concurrent_executions_threshold       | The number of concurrent executions before triggering the alarm. Default 300              |
| concurrent_executions_period          | The number of seconds per evaluation period. Default 60                                   |
| concurrent_execution_number_of_periods| The number of periods the concurrent execution threshold must be breached. Default 3      |
| alarm_actions                         | A list of SNS topic ARNs to send alarm events to                                          |
| alarm_actions_enabled                 | Set to false to silence the alarms. Default true                                          |
| tags                                  | A map of tags to be added to AWS resources                                                |

#### Outputs

None.

#### Example usage

```hcl
module lambda_alarms {
  source                        = "github.com/glenthomas/terraform-aws-cloudwatch//lambda-alarms"
  alarm_actions                 = [module.slack_alerts.sns_topic_arn]
  function_name                 = aws_lambda_function.my_function.function_name
  error_rate_threshold          = 1
  error_rate_number_of_periods  = 3
}
```

### lambda-metrics

Use this module to create CloudWatch metrics for lambda functions.
- LambdaMaxMemoryUsed - The maximum memory used during function invocation.
- LambdaColdStartDuration - The duration of the function invocation for cold start executions.
- LambdaColdStartCount - A count of cold start invocations.
- LambdaInitDuration - The time taken for lambda to prepare the execution environment on cold start.
- LambdaBilledDuration - The duration used for lambda billing for the invocation.

The CloudWatch log group must exist before this module can be deployed. You can use the [aws_cloudwatch_log_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) resources to create it.

#### Inputs

| Name                          | Description                                                                         |
| ----------------------------- | ----------------------------------------------------------------------------------- |
| lambda_function_name          | The name of your lambda function.                                                   |
| lambda_log_group_name         | The name of your lambda CloudWatch log group.                                       |
| create_max_memory_metric      | Set to true to create the LambdaMaxMemoryUsed metric. Defaults to true.             |
| create_cold_duration_metric   | Set to true to create the LambdaColdStartDuration metric. Defaults to true.         |
| create_cold_count_metric      | Set to true to create the LambdaColdStartCount metric. Defaults to true.            |
| create_init_duration_metric   | Set to true to create the LambdaInitDuration metric. Defaults to false.             |
| create_billed_duration_metric | Set to true to create the LambdaBilledDuration metric. Defaults to false.           |

#### Outputs

None.

#### Example usage

```hcl
module "lambda_metrics" {
  source                 = "github.com/glenthomas/terraform-aws-cloudwatch//lambda-metrics"
  lambda_function_name   = aws_lambda_function.my_function.function_name
  lambda_log_group_name  = aws_cloudwatch_log_group.my_function.name
}
```

### sqs-queue-alarms

Use this module to create CloudWatch alarms for SQS queues.
- Maximum message age
- Messages in the deadletter queue

#### Inputs

| Name                            | Description                                                                     |
| ------------------------------- | ------------------------------------------------------------------------------- |
| queue_name                      | The name of your SQS queue                                                      |
| deadletter_queue_name           | The name of your SQS deadletter queue                                           |
| message_age_threshold           | The maximum message age in seconds before triggering the alarm. Default 900     |
| message_age_period              | The number of seconds per evaluation period. Default 60                         |
| message_age_number_of_periods   | The number of periods the message age threshold must be breached for. Default 1 |
| alarm_actions                   | A list of SNS topic ARNs to send alarm events to                                |
| alarm_actions_enabled           | Set to false to silence the alarms. Default true                                |
| tags                            | A map of tags to be added to AWS resources                                      |

#### Outputs

None.

#### Example usage

```hcl
module sqs_alarms {
  source                = "github.com/glenthomas/terraform-aws-cloudwatch//sqs-queue-alarms"
  alarm_actions         = [module.slack_alerts.sns_topic_arn]
  queue_name            = aws_sqs_queue.my_queue.name
  deadletter_queue_name = aws_sqs_queue.my_deadletter_queue.name
}
```

### widget-metrics

Use this module to create metric expressions to place on a CloudWatch dashboard widget.

#### Inputs

| Name                         | Description                                                                 |
| ---------------------------- | --------------------------------------------------------------------------- |
| metric_namespace             | The CloudWatch metrics namespace to get metrics for                         |
| http_services                | A list of HTTP service names as used in the common monitoring package       |
| http_hosts                   | A list of HTTP host names as used in the common monitoring package          |
| http_operation_names         | A list of HTTP operation names as used in the common monitoring package     |
| sqs_queues                   | A list of SQS queue names as used in the common monitoring package          |
| sqs_operation_names          | A list of SQS operation names as used in the common monitoring package      |
| sns_topics                   | A list of SNS topic names as used in the common monitoring package          |
| sns_operation_names          | A list of SNS operation names as used in the common monitoring package      |
| dynamodb_tables              | A list of DynamoDB table names as used in the common monitoring package     |
| dynamodb_operation_names     | A list of DynamoDB operation names as used in the common monitoring package |
| s3_buckets                   | A list of S3 bucket names as used in the common monitoring package          |
| s3_operation_names           | A list of S3 operation names as used in the common monitoring package       |

#### Outputs

| Name                                                          | Description                                             |
| ------------------------------------------------------------- | ------------------------------------------------------- |
| dynamodb_request_count                                        | Count of DynamoDb requests                              |
| dynamodb_request_duration_average                             | Average DynamoDb request duration                       |
| dynamodb_request_duration_p95                                 | p95 DynamoDb request duration                           |
| dynamodb_timeout_count                                        | Count of DynamoDb request timeouts                      |
| dynamodb_error_count                                          | Count of DynamoDb error responses                       |
| dynamodb_table_request_count_search                           | Count of DynamoDb requests by tables                    |
| dynamodb_table_request_count                                  | Count of DynamoDb requests by dynamodb_tables input     |
| dynamodb_table_request_duration_average_search                | Average DynamoDb request duration by tables             |
| dynamodb_table_request_duration_average                       | Average DynamoDb request duration by dynamodb_tables input |
| dynamodb_table_request_duration_p95_search                    | p95 DynamoDb request duration by tables                 |
| dynamodb_table_request_duration_p95                           | p95 DynamoDb request duration by dynamodb_tables input  |
| dynamodb_table_timeout_count_search                           | Count of DynamoDb request timeouts by tables            |
| dynamodb_table_timeout_count                                  | Count of DynamoDb request timeouts by dynamodb_tables input |
| dynamodb_table_error_count_search                             | Count of DynamoDb error responses by tables             |
| dynamodb_table_error_count                                    | Count of DynamoDb error responses by dynamodb_tables input |
| dynamodb_table_operation_name_request_count_search            | Count of DynamoDb requests by all tables and operation names |
| dynamodb_table_operation_name_request_count                   | Count of DynamoDb requests by dynamodb_tables and dynamodb_operation_names inputs |
| dynamodb_table_operation_name_request_duration_average_search | Average DynamoDb request duration by all tables and operation names |
| dynamodb_table_operation_name_request_duration_average        | Average DynamoDb request duration by dynamodb_tables and dynamodb_operation_names inputs |
| dynamodb_table_operation_name_request_duration_p95_search     | p95 DynamoDb request duration by all tables and operation names |
| dynamodb_table_operation_name_request_duration_p95            | p95 DynamoDb request duration by dynamodb_tables and dynamodb_operation_names inputs |
| dynamodb_table_operation_name_timeout_count_search            | Count of DynamoDb request timeouts by all tables and operation names |
| dynamodb_table_operation_name_timeout_count                   | Count of DynamoDb request timeouts by dynamodb_tables and dynamodb_operation_names inputs |
| dynamodb_table_operation_name_error_count_search              | Count of DynamoDb error responses by all tables and operation names |
| dynamodb_table_operation_name_error_count                     | Count of DynamoDb error responses by dynamodb_tables and dynamodb_operation_names inputs |
| http_request_count                                            | Count of HTTP requests                                  |
| http_duration_average                                         | Average HTTP request duration                           |
| http_duration_p95                                             | p95 HTTP request duration                               |
| http_5xx_status_count                                         | Count of 5xx HTTP responses                             |
| http_4xx_status_count                                         | Count of 4xx HTTP responses                             |
| http_2xx_status_count                                         | Count of 2xx HTTP responses                             |
| http_timeout_count                                            | Count of HTTP request timeouts                          |
| http_service_request_count_search                             | Count of HTTP requests by all service names             |
| http_service_request_count                                    | Count of HTTP requests by http_services input           |
| http_service_duration_average_search                          | Average HTTP request duration by all service names      |
| http_service_duration_average                                 | Average HTTP request duration by http_services input    |
| http_service_duration_p95_search                              | p95 HTTP request duration by all service names          |
| http_service_duration_p95                                     | p95 HTTP request duration by http_services input        |
| http_service_5xx_status_count_search                          | Count of 5xx HTTP responses by all service names        |
| http_service_5xx_status_count                                 | Count of 5xx HTTP responses by http_services input      |
| http_service_4xx_status_count_search                          | Count of 4xx HTTP responses by all service names        |
| http_service_4xx_status_count                                 | Count of 4xx HTTP responses by http_services input      |
| http_service_2xx_status_count_search                          | Count of 2xx HTTP responses by all service names        |
| http_service_2xx_status_count                                 | Count of 2xx HTTP responses by http_services input      |
| http_service_timeout_count_search                             | Count of HTTP request timeouts by all service names     |
| http_service_timeout_count                                    | Count of HTTP request timeouts by http_services input   |
| http_host_request_count_search                                | Count of HTTP requests by all host names                |
| http_host_request_count                                       | Count of HTTP requests by http_hosts input              |
| http_host_duration_average_search                             | Average HTTP request duration by all host names         |
| http_host_duration_average                                    | Average HTTP request duration by http_hosts input       |
| http_host_duration_p95_search                                 | p95 HTTP request duration by all host names             |
| http_host_duration_p95                                        | p95 HTTP request duration by http_hosts input           |
| http_host_5xx_status_count_search                             | Count of 5xx HTTP responses by all host names           |
| http_host_5xx_status_count                                    | Count of 5xx HTTP responses by http_hosts input         |
| http_host_4xx_status_count_search                             | Count of 4xx HTTP responses by all host names           |
| http_host_4xx_status_count                                    | Count of 4xx HTTP responses by http_hosts input         |
| http_host_2xx_status_count_search                             | Count of 2xx HTTP responses by all host names           |
| http_host_2xx_status_count                                    | Count of 2xx HTTP responses by http_hosts input         |
| http_host_timeout_count_search                                | Count of HTTP request timeouts by all host names        |
| http_host_timeout_count                                       | Count of HTTP request timeouts by http_hosts input      |
| http_operation_request_count_search                           | Count of HTTP requests by all operation names           |
| http_operation_request_count                                  | Count of HTTP requests by http_operation_names input    |
| http_operation_duration_average_search                        | Average HTTP request duration by all operation names    |
| http_operation_duration_average                               | Average HTTP request duration by http_operation_names input |
| http_operation_duration_p95_search                            | p95 HTTP request duration by all operation names        |
| http_operation_duration_p95                                   | p95 HTTP request duration by http_operation_names input |
| http_operation_5xx_status_count_search                        | Count of 5xx HTTP responses by all operation names      |
| http_operation_5xx_status_count                               | Count of 5xx HTTP responses by http_operation_names input |
| http_operation_4xx_status_count_search                        | Count of 4xx HTTP responses by all operation names      |
| http_operation_4xx_status_count                               | Count of 4xx HTTP responses by http_operation_names input |
| http_operation_2xx_status_count_search                        | Count of 2xx HTTP responses by all operation names      |
| http_operation_2xx_status_count                               | Count of 2xx HTTP responses by http_operation_names input |
| http_operation_timeout_count_search                           | Count of HTTP request timeouts by all operation names   |
| http_operation_timeout_count                                  | Count of HTTP request timeouts by http_operation_names input |
| http_service_operation_request_count_search                   | Count of HTTP requests by all services and operation names |
| http_service_operation_request_count                          | Count of HTTP requests by http_services and http_operation_names inputs |
| http_service_operation_duration_average_search                | Average HTTP request duration by all services and operation names |
| http_service_operation_duration_average                       | Average HTTP request duration by http_services and http_operation_names inputs |
| http_service_operation_duration_p95_search                    | p95 HTTP request duration by all services and operation names |
| http_service_operation_duration_p95                           | p95 HTTP request duration by http_services and http_operation_names inputs |
| http_service_operation_5xx_status_count_search                | Count of 5xx HTTP responses by all services and operation names |
| http_service_operation_5xx_status_count                       | Count of 5xx HTTP responses by http_services and http_operation_names inputs |
| http_service_operation_4xx_status_count_search                | Count of 4xx HTTP responses by all services and operation names |
| http_service_operation_4xx_status_count                       | Count of 4xx HTTP responses by http_services and http_operation_names inputs |
| http_service_operation_2xx_status_count_search                | Count of 2xx HTTP responses by all services and operation names |
| http_service_operation_2xx_status_count                       | Count of 2xx HTTP responses by http_services and http_operation_names inputs |
| http_service_operation_timeout_count_search                   | Count of HTTP request timeouts by all services and operation names |
| http_service_operation_timeout_count                          | Count of HTTP request timeouts by http_services and http_operation_names inputs |
| s3_request_count                                              | Count of S3 requests                                    |
| s3_duration_average                                           | Average S3 request duration                             |
| s3_duration_p95                                               | p95 S3 request duration                                 |
| s3_timeout_count                                              | Count of S3 request timeouts                            |
| s3_error_count                                                | Count of S3 error responses                             |
| s3_bucket_request_count_search                                | Count of S3 requests by all buckets                     |
| s3_bucket_request_count                                       | Count of S3 requests by s3_buckets input                |
| s3_bucket_duration_average_search                             | Average S3 request duration by all buckets              |
| s3_bucket_duration_average                                    | Average S3 request duration by s3_buckets input         |
| s3_bucket_duration_p95_search                                 | p95 S3 request duration by all buckets                  |
| s3_bucket_duration_p95                                        | p95 S3 request duration by s3_buckets input             |
| s3_bucket_timeout_count_search                                | Count of S3 request timeouts by all buckets             |
| s3_bucket_timeout_count                                       | Count of S3 request timeouts by s3_buckets input        |
| s3_bucket_error_count_search                                  | Count of S3 error responses by all buckets        |
| s3_bucket_error_count                                         | Count of S3 error responses by s3_buckets input   |
| s3_bucket_operation_name_request_count_search                 | Count of S3 requests by all buckets and operation names |
| s3_bucket_operation_name_request_count                        | Count of S3 requests by s3_buckets and s3_operation_names inputs |
| s3_bucket_operation_name_duration_average_search              | Average S3 request duration by all buckets and operation names |
| s3_bucket_operation_name_duration_average                     | Average S3 request duration by s3_buckets and s3_operation_names inputs |
| s3_bucket_operation_name_duration_p95_search                  | p95 S3 request duration by all buckets and operation names |
| s3_bucket_operation_name_duration_p95                         | p95 S3 request duration by s3_buckets and s3_operation_names inputs |
| s3_bucket_operation_name_timeout_count_search                 | Count of S3 request timeouts by all buckets and operation names |
| s3_bucket_operation_name_timeout_count                        | Count of S3 request timeouts by s3_buckets and s3_operation_names inputs |
| s3_bucket_operation_name_error_count_search                   | Count of S3 error responses by all buckets and operation names |
| s3_bucket_operation_name_error_count                          | Count of S3 error responses by s3_buckets and s3_operation_names inputs |
| s3_bucket_operation_type_request_count_search                 | Count of S3 requests by all buckets and operation types |
| s3_bucket_operation_type_request_count                        | Count of S3 requests by s3_buckets and s3_operation_types inputs |
| s3_bucket_operation_type_duration_average_search              | Average S3 request duration by all buckets and operation types |
| s3_bucket_operation_type_duration_average                     | Average S3 request duration by s3_buckets and s3_operation_types inputs |
| s3_bucket_operation_type_duration_p95_search                  | p95 S3 request duration by all buckets and operation types |
| s3_bucket_operation_type_duration_p95                         | p95 S3 request duration by s3_buckets and s3_operation_types inputs |
| s3_bucket_operation_type_timeout_count_search                 | Count of S3 request timeouts by all buckets and operation types |
| s3_bucket_operation_type_timeout_count                        | Count of S3 request timeouts by s3_buckets and s3_operation_types inputs |
| s3_bucket_operation_type_error_count_search                   | Count of S3 error responses by all buckets and operation types |
| s3_bucket_operation_type_error_count                          | Count of S3 error responses by s3_buckets and s3_operation_types inputs |
| sns_request_count                                             | Count of SNS requests                                   |
| sns_duration_average                                          | Average SNS request duration                            |
| sns_duration_p95                                              | p95 SNS request duration                                |
| sns_timeout_count                                             | Count of SNS request timeouts                           |
| sns_error_count                                               | Count of SNS error responses                            |
| sns_topic_request_count_search                                | Count of SNS requests by all topics                     |
| sns_topic_request_count                                       | Count of SNS requests by sns_topics input               |
| sns_topic_duration_average_search                             | Average SNS request duration by all topics              |
| sns_topic_duration_average                                    | Average SNS request duration by sns_topics input        |
| sns_topic_duration_p95_search                                 | p95 SNS request duration by all topics                  |
| sns_topic_duration_p95                                        | p95 SNS request duration by sns_topics input            |
| sns_topic_timeout_count_search                                | Count of SNS request timeouts by all topics             |
| sns_topic_timeout_count                                       | Count of SNS request timeouts by sns_topics input       |
| sns_topic_error_count_search                                  | Count of SNS error responses by all topics              |
| sns_topic_error_count                                         | Count of SNS error responses by sns_topics input        |
| sns_topic_operation_name_request_count_search                 | Count of SNS requests by all topics and operation names |
| sns_topic_operation_name_request_count                        | Count of SNS requests by sns_topics and sns_operation_names inputs |
| sns_topic_operation_name_duration_average_search              | Average SNS request duration by all topics and operation names |
| sns_topic_operation_name_duration_average                     | Average SNS request duration by sns_topics and sns_operation_names inputs |
| sns_topic_operation_name_duration_p95_search                  | p95 SNS request duration by all topics and operation names |
| sns_topic_operation_name_duration_p95                         | p95 SNS request duration by sns_topics and sns_operation_names inputs |
| sns_topic_operation_name_timeout_count_search                 | Count of SNS request timeouts by all topics and operation names |
| sns_topic_operation_name_timeout_count                        | Count of SNS request timeouts by sns_topics and sns_operation_names inputs |
| sns_topic_operation_name_error_count_search                   | Count of SNS error responses by all topics and operation names |
| sns_topic_operation_name_error_count                          | Count of SNS error responses sns_topics and sns_operation_names inputs |
| sqs_request_count                                             | Count of SQS requests                                   |
| sqs_duration_average                                          | Average SQS request duration                            |
| sqs_duration_p95                                              | p95 SQS request duration                                |
| sqs_timeout_count                                             | Count of SQS request timeouts                           |
| sqs_error_count                                               | Count of SQS error responses                            |
| sqs_queue_request_count_search                                | Count of SQS requests by all queues                     |
| sqs_queue_request_count                                       | Count of SQS requests by sqs_queues input               |
| sqs_queue_duration_average_search                             | Average SQS request duration by all queues              |
| sqs_queue_duration_average                                    | Average SQS request duration by sqs_queues input        |
| sqs_queue_duration_p95_search                                 | p95 SQS request duration by all queues                  |
| sqs_queue_duration_p95                                        | p95 SQS request duration by sqs_queues input            |
| sqs_queue_timeout_count_search                                | Count of SQS request timeouts by all queues             |
| sqs_queue_timeout_count                                       | Count of SQS request timeouts by sqs_queues input       |
| sqs_queue_error_count_search                                  | Count of SQS error responses by all queues              |
| sqs_queue_error_count                                         | Count of SQS error responses by sqs_queues input        |
| sqs_queue_operation_name_request_count_search                 | Count of SQS requests by all queues and operation names |
| sqs_queue_operation_name_request_count                        | Count of SQS requests by sqs_queues and sqs_operation_names inputs |
| sqs_queue_operation_name_duration_average_search              | Average SQS request duration by all queues and operation names |
| sqs_queue_operation_name_duration_average                     | Average SQS request duration by sqs_queues and sqs_operation_names inputs |
| sqs_queue_operation_name_duration_p95_search                  | p95 SQS request duration by all queues and operation names |
| sqs_queue_operation_name_duration_p95                         | p95 SQS request duration by sqs_queues and sqs_operation_names inputs |
| sqs_queue_operation_name_timeout_count_search                 | Count of SQS request timeouts by all queues and operation names |
| sqs_queue_operation_name_timeout_count                        | Count of SQS request timeouts by sqs_queues and sqs_operation_names inputs |
| sqs_queue_operation_name_error_count_search                   | Count of SQS error responses by all queues and operation names |
| sqs_queue_operation_name_error_count                          | Count of SQS error responses sqs_queues and sqs_operation_names inputs |

#### Example usage

```hcl
module metrics {
  source            = "github.com/glenthomas/terraform-aws-cloudwatch//widget-metrics"
  metric_namespace  = "my-component"
}
```
