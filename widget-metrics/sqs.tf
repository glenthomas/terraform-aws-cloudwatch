locals {
  sqs_message_count_metric_name = "sqs-message-count"
  sqs_request_count_metric_name = "sqs-request-count"
  sqs_request_duration_metric_name = "sqs-request-duration"
  sqs_request_timeout_metric_name = "sqs-request-timeout"
  sqs_request_error_metric_name = "sqs-request-error"
}

# No dimensions

output sqs_request_count {
  value = [
    [
      var.metric_namespace,
      local.sqs_request_count_metric_name,
      {
        label: "SQS request count",
        stat: "Sum"
      }
    ]
  ]
}

output sqs_message_count {
  value = [
    [
      var.metric_namespace,
      local.sqs_message_count_metric_name,
      {
        label: "SQS messages sent",
        stat: "Sum"
      }
    ]
  ]
}

output sqs_request_duration_average {
  value = [
    [
      var.metric_namespace,
      local.sqs_request_duration_metric_name,
      {
        label: "SQS duration average",
        stat: "Average"
      }
    ]
  ]
}

output sqs_request_duration_p95 {
  value = [
    [
      var.metric_namespace,
      local.sqs_request_duration_metric_name,
      {
        label: "SQS duration p95",
        stat: "p95"
      }
    ]
  ]
}

output sqs_timeout_count {
  value = [
    [
      var.metric_namespace,
      local.sqs_request_timeout_metric_name,
      {
        label: "SQS timeouts",
        stat: "Sum"
      }
    ]
  ]
}

output sqs_error_count {
  value = [
    [
      var.metric_namespace,
      local.sqs_request_error_metric_name,
      {
        label: "SQS errors",
        stat: "Sum"
      }
    ]
  ]
}

# By QueueName

output sqs_queue_request_count_search {
  value = [
    [ { "expression": "SEARCH('{${var.metric_namespace},QueueName} MetricName=\"${local.sqs_request_count_metric_name}\"', 'Sum', 60)", "label": "", "id": "sumRequests" } ]
  ]
}

output sqs_queue_request_count {
  value = [
    for queueName in var.sqs_queues : [
      var.metric_namespace,
      local.sqs_request_count_metric_name,
      "QueueName", queueName,
      {
        label: "${queueName} request count",
        stat: "Sum"
      }
    ]
  ]
}

output sqs_queue_message_count_search {
  value = [
    [ { "expression": "SEARCH('{${var.metric_namespace},QueueName} MetricName=\"${local.sqs_message_count_metric_name}\"', 'Sum', 60)", "label": "", "id": "sumMessages" } ]
  ]
}

output sqs_queue_message_count {
  value = [
    for queueName in var.sqs_queues : [
      var.metric_namespace,
      local.sqs_message_count_metric_name,
      "QueueName", queueName,
      {
        label: "${queueName} messages sent",
        stat: "Sum"
      }
    ]
  ]
}

output sqs_queue_request_duration_average_search {
  value = [
    [ { "expression": "SEARCH('{${var.metric_namespace},QueueName} MetricName=\"${local.sqs_request_duration_metric_name}\"', 'Average', 60)", "label": "", "id": "averageDuration" } ]
  ]
}

output sqs_queue_request_duration_average {
  value = [
    for queueName in var.sqs_queues : [
      var.metric_namespace,
      local.sqs_request_duration_metric_name,
      "QueueName", queueName,
      {
        label: "${queueName} duration average",
        stat: "Average"
      }
    ]
  ]
}

output sqs_queue_request_duration_p95_search {
  value = [
    [ { "expression": "SEARCH('{${var.metric_namespace},QueueName} MetricName=\"${local.sqs_request_duration_metric_name}\"', 'p95', 60)", "label": "", "id": "p95Duration" } ]
  ]
}

output sqs_queue_request_duration_p95 {
  value = [
    for queueName in var.sqs_queues : [
      var.metric_namespace,
      local.sqs_request_duration_metric_name,
      "QueueName", queueName,
      {
        label: "${queueName} duration p95",
        stat: "p95"
      }
    ]
  ]
}

output sqs_queue_timeout_count_search {
  value = [
    [ { "expression": "SEARCH('{${var.metric_namespace},QueueName} MetricName=\"${local.sqs_request_timeout_metric_name}\"', 'Sum', 60)", "label": "", "id": "sumTimeouts" } ]
  ]
}

output sqs_queue_timeout_count {
  value = [
    for queueName in var.sqs_queues : [
      var.metric_namespace,
      local.sqs_request_timeout_metric_name,
      "QueueName", queueName,
      {
        label: "${queueName} timeouts",
        stat: "Sum"
      }
    ]
  ]
}

output sqs_queue_error_count_search {
  value = [
    [ { "expression": "SEARCH('{${var.metric_namespace},QueueName} MetricName=\"${local.sqs_request_error_metric_name}\"', 'Sum', 60)", "label": "", "id": "sumErrors" } ]
  ]
}

output sqs_queue_error_count {
  value = [
    for queueName in var.sqs_queues : [
      var.metric_namespace,
      local.sqs_request_error_metric_name,
      "QueueName", queueName,
      {
        label: "${queueName} errors",
        stat: "Sum"
      }
    ]
  ]
}

# By QueueName / OperationName

output sqs_queue_operation_name_request_count_search {
  value = [
    [ { "expression": "SEARCH('{${var.metric_namespace},QueueName,OperationName} MetricName=\"${local.sqs_request_count_metric_name}\"', 'Sum', 60)", "label": "", "id": "sumRequests" } ]
  ]
}

output sqs_queue_operation_name_request_count {
  value = [
    for queueOperationPair in setproduct(var.sqs_queues, var.sqs_operation_names) : [
      var.metric_namespace,
      local.sqs_request_count_metric_name,
      "QueueName", queueOperationPair[0],
      "OperationName", queueOperationPair[1],
      {
        label: "${queueOperationPair[0]}/${queueOperationPair[1]} request count",
        stat: "Sum"
      }
    ]
  ]
}

output sqs_queue_operation_name_message_count_search {
  value = [
    [ { "expression": "SEARCH('{${var.metric_namespace},QueueName,OperationName} MetricName=\"${local.sqs_message_count_metric_name}\"', 'Sum', 60)", "label": "", "id": "sumMessages" } ]
  ]
}

output sqs_queue_operation_name_message_count {
  value = [
    for queueOperationPair in setproduct(var.sqs_queues, var.sqs_operation_names) : [
      var.metric_namespace,
      local.sqs_message_count_metric_name,
      "QueueName", queueOperationPair[0],
      "OperationName", queueOperationPair[1],
      {
        label: "${queueOperationPair[0]}/${queueOperationPair[1]} messages sent",
        stat: "Sum"
      }
    ]
  ]
}

output sqs_queue_operation_name_request_duration_average_search {
  value = [
    [ { "expression": "SEARCH('{${var.metric_namespace},QueueName,OperationName} MetricName=\"${local.sqs_request_duration_metric_name}\"', 'Average', 60)", "label": "", "id": "averageDuration" } ]
  ]
}

output sqs_queue_operation_name_request_duration_average {
  value = [
    for queueOperationPair in setproduct(var.sqs_queues, var.sqs_operation_names) : [
      var.metric_namespace,
      local.sqs_request_duration_metric_name,
      "QueueName", queueOperationPair[0],
      "OperationName", queueOperationPair[1],
      {
        label: "${queueOperationPair[0]}/${queueOperationPair[1]} duration average",
        stat: "Average"
      }
    ]
  ]
}

output sqs_queue_operation_name_request_duration_p95_search {
  value = [
    [ { "expression": "SEARCH('{${var.metric_namespace},QueueName,OperationName} MetricName=\"${local.sqs_request_duration_metric_name}\"', 'p95', 60)", "label": "", "id": "p95Duration" } ]
  ]
}

output sqs_queue_operation_name_request_duration_p95 {
  value = [
    for queueOperationPair in setproduct(var.sqs_queues, var.sqs_operation_names) : [
      var.metric_namespace,
      local.sqs_request_duration_metric_name,
      "QueueName", queueOperationPair[0],
      "OperationName", queueOperationPair[1],
      {
        label: "${queueOperationPair[0]}/${queueOperationPair[1]} duration p95",
        stat: "p95"
      }
    ]
  ]
}

output sqs_queue_operation_name_timeout_count_search {
  value = [
    [ { "expression": "SEARCH('{${var.metric_namespace},QueueName,OperationName} MetricName=\"${local.sqs_request_timeout_metric_name}\"', 'Sum', 60)", "label": "", "id": "sumTimeouts" } ]
  ]
}

output sqs_queue_operation_name_timeout_count {
  value = [
    for queueOperationPair in setproduct(var.sqs_queues, var.sqs_operation_names) : [
      var.metric_namespace,
      local.sqs_request_timeout_metric_name,
      "QueueName", queueOperationPair[0],
      "OperationName", queueOperationPair[1],
      {
        label: "${queueOperationPair[0]}/${queueOperationPair[1]} timeouts",
        stat: "Sum"
      }
    ]
  ]
}

output sqs_queue_operation_name_error_count_search {
  value = [
    [ { "expression": "SEARCH('{${var.metric_namespace},QueueName,OperationName} MetricName=\"${local.sqs_request_error_metric_name}\"', 'Sum', 60)", "label": "", "id": "sumErrors" } ]
  ]
}

output sqs_queue_operation_name_error_count {
  value = [
    for queueOperationPair in setproduct(var.sqs_queues, var.sqs_operation_names) : [
      var.metric_namespace,
      local.sqs_request_error_metric_name,
      "QueueName", queueOperationPair[0],
      "OperationName", queueOperationPair[1],
      {
        label: "${queueOperationPair[0]}/${queueOperationPair[1]} errors",
        stat: "Sum"
      }
    ]
  ]
}

# By QueueName / OperationType

output sqs_queue_operation_type_request_count_search {
  value = [
    [ { "expression": "SEARCH('{${var.metric_namespace},QueueName,OperationType} MetricName=\"${local.sqs_request_count_metric_name}\"', 'Sum', 60)", "label": "", "id": "sumRequests" } ]
  ]
}

output sqs_queue_operation_type_request_count {
  value = [
    for queueOperationPair in setproduct(var.sqs_queues, var.sqs_operation_types) : [
      var.metric_namespace,
      local.sqs_request_count_metric_name,
      "QueueName", queueOperationPair[0],
      "OperationType", queueOperationPair[1],
      {
        label: "${queueOperationPair[0]}/${queueOperationPair[1]} request count",
        stat: "Sum"
      }
    ]
  ]
}

output sqs_queue_operation_type_message_count_search {
  value = [
    [ { "expression": "SEARCH('{${var.metric_namespace},QueueName,OperationType} MetricName=\"${local.sqs_message_count_metric_name}\"', 'Sum', 60)", "label": "", "id": "sumMessages" } ]
  ]
}

output sqs_queue_operation_type_message_count {
  value = [
    for queueOperationPair in setproduct(var.sqs_queues, var.sqs_operation_types) : [
      var.metric_namespace,
      local.sqs_message_count_metric_name,
      "QueueName", queueOperationPair[0],
      "OperationType", queueOperationPair[1],
      {
        label: "${queueOperationPair[0]}/${queueOperationPair[1]} messages sent",
        stat: "Sum"
      }
    ]
  ]
}

output sqs_queue_operation_type_request_duration_average_search {
  value = [
    [ { "expression": "SEARCH('{${var.metric_namespace},QueueName,OperationType} MetricName=\"${local.sqs_request_duration_metric_name}\"', 'Average', 60)", "label": "", "id": "averageDuration" } ]
  ]
}

output sqs_queue_operation_type_request_duration_average {
  value = [
    for queueOperationPair in setproduct(var.sqs_queues, var.sqs_operation_types) : [
      var.metric_namespace,
      local.sqs_request_duration_metric_name,
      "QueueName", queueOperationPair[0],
      "OperationType", queueOperationPair[1],
      {
        label: "${queueOperationPair[0]}/${queueOperationPair[1]} duration average",
        stat: "Average"
      }
    ]
  ]
}

output sqs_queue_operation_type_request_duration_p95_search {
  value = [
    [ { "expression": "SEARCH('{${var.metric_namespace},QueueName,OperationType} MetricName=\"${local.sqs_request_duration_metric_name}\"', 'p95', 60)", "label": "", "id": "p95Duration" } ]
  ]
}

output sqs_queue_operation_type_request_duration_p95 {
  value = [
    for queueOperationPair in setproduct(var.sqs_queues, var.sqs_operation_types) : [
      var.metric_namespace,
      local.sqs_request_duration_metric_name,
      "QueueName", queueOperationPair[0],
      "OperationType", queueOperationPair[1],
      {
        label: "${queueOperationPair[0]}/${queueOperationPair[1]} duration p95",
        stat: "p95"
      }
    ]
  ]
}

output sqs_queue_operation_type_timeout_count_search {
  value = [
    [ { "expression": "SEARCH('{${var.metric_namespace},QueueName,OperationType} MetricName=\"${local.sqs_request_timeout_metric_name}\"', 'Sum', 60)", "label": "", "id": "sumTimeouts" } ]
  ]
}

output sqs_queue_operation_type_timeout_count {
  value = [
    for queueOperationPair in setproduct(var.sqs_queues, var.sqs_operation_types) : [
      var.metric_namespace,
      local.sqs_request_timeout_metric_name,
      "QueueName", queueOperationPair[0],
      "OperationType", queueOperationPair[1],
      {
        label: "${queueOperationPair[0]}/${queueOperationPair[1]} timeouts",
        stat: "Sum"
      }
    ]
  ]
}

output sqs_queue_operation_type_error_count_search {
  value = [
    [ { "expression": "SEARCH('{${var.metric_namespace},QueueName,OperationType} MetricName=\"${local.sqs_request_error_metric_name}\"', 'Sum', 60)", "label": "", "id": "sumErrors" } ]
  ]
}

output sqs_queue_operation_type_error_count {
  value = [
    for queueOperationPair in setproduct(var.sqs_queues, var.sqs_operation_types) : [
      var.metric_namespace,
      local.sqs_request_error_metric_name,
      "QueueName", queueOperationPair[0],
      "OperationType", queueOperationPair[1],
      {
        label: "${queueOperationPair[0]}/${queueOperationPair[1]} errors",
        stat: "Sum"
      }
    ]
  ]
}