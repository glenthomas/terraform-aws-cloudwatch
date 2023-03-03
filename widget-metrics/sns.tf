locals {
  sns_message_count_metric_name = "sns-message-count"
  sns_request_count_metric_name = "sns-request-count"
  sns_request_duration_metric_name = "sns-request-duration"
  sns_request_timeout_metric_name = "sns-request-timeout"
  sns_request_error_metric_name = "sns-request-error"
}

# No dimensions

output sns_request_count {
  value = [
    [
      var.metric_namespace,
      local.sns_request_count_metric_name,
      {
        label: "SNS request count",
        stat: "Sum"
      }
    ]
  ]
}

output sns_message_count {
  value = [
    [
      var.metric_namespace,
      local.sns_message_count_metric_name,
      {
        label: "SNS messages sent",
        stat: "Sum"
      }
    ]
  ]
}

output sns_request_duration_average {
  value = [
    [
      var.metric_namespace,
      local.sns_request_duration_metric_name,
      {
        label: "SNS duration average",
        stat: "Average"
      }
    ]
  ]
}

output sns_request_duration_p95 {
  value = [
    [
      var.metric_namespace,
      local.sns_request_duration_metric_name,
      {
        label: "SNS duration p95",
        stat: "p95"
      }
    ]
  ]
}

output sns_timeout_count {
  value = [
    [
      var.metric_namespace,
      local.sns_request_timeout_metric_name,
      {
        label: "SNS timeouts",
        stat: "Sum"
      }
    ]
  ]
}

output sns_error_count {
  value = [
    [
      var.metric_namespace,
      local.sns_request_error_metric_name,
      {
        label: "SNS errors",
        stat: "Sum"
      }
    ]
  ]
}

# By TopicName

output sns_topic_request_count_search {
  value = [
    [ { "expression": "SEARCH('{${var.metric_namespace},TopicName} MetricName=\"${local.sns_request_count_metric_name}\"', 'Sum', 60)", "label": "", "id": "sumRequests" } ]
  ]
}

output sns_topic_request_count {
  value = [
    for queueName in var.sns_topics : [
      var.metric_namespace,
      local.sns_request_count_metric_name,
      "TopicName", queueName,
      {
        label: "${queueName} request count",
        stat: "Sum"
      }
    ]
  ]
}

output sns_topic_message_count_search {
  value = [
    [ { "expression": "SEARCH('{${var.metric_namespace},TopicName} MetricName=\"${local.sns_message_count_metric_name}\"', 'Sum', 60)", "label": "", "id": "sumMessages" } ]
  ]
}

output sns_topic_message_count {
  value = [
    for queueName in var.sns_topics : [
      var.metric_namespace,
      local.sns_message_count_metric_name,
      "TopicName", queueName,
      {
        label: "${queueName} messages sent",
        stat: "Sum"
      }
    ]
  ]
}

output sns_topic_request_duration_average_search {
  value = [
    [ { "expression": "SEARCH('{${var.metric_namespace},TopicName} MetricName=\"${local.sns_request_duration_metric_name}\"', 'Average', 60)", "label": "", "id": "averageDuration" } ]
  ]
}

output sns_topic_request_duration_average {
  value = [
    for queueName in var.sns_topics : [
      var.metric_namespace,
      local.sns_request_duration_metric_name,
      "TopicName", queueName,
      {
        label: "${queueName} duration average",
        stat: "Average"
      }
    ]
  ]
}

output sns_topic_request_duration_p95_search {
  value = [
    [ { "expression": "SEARCH('{${var.metric_namespace},TopicName} MetricName=\"${local.sns_request_duration_metric_name}\"', 'p95', 60)", "label": "", "id": "p95Duration" } ]
  ]
}

output sns_topic_request_duration_p95 {
  value = [
    for queueName in var.sns_topics : [
      var.metric_namespace,
      local.sns_request_duration_metric_name,
      "TopicName", queueName,
      {
        label: "${queueName} duration p95",
        stat: "p95"
      }
    ]
  ]
}

output sns_topic_timeout_count_search {
  value = [
    [ { "expression": "SEARCH('{${var.metric_namespace},TopicName} MetricName=\"${local.sns_request_timeout_metric_name}\"', 'Sum', 60)", "label": "", "id": "sumTimeouts" } ]
  ]
}

output sns_topic_timeout_count {
  value = [
    for queueName in var.sns_topics : [
      var.metric_namespace,
      local.sns_request_timeout_metric_name,
      "TopicName", queueName,
      {
        label: "${queueName} timeouts",
        stat: "Sum"
      }
    ]
  ]
}

output sns_topic_error_count_search {
  value = [
    [ { "expression": "SEARCH('{${var.metric_namespace},TopicName} MetricName=\"${local.sns_request_error_metric_name}\"', 'Sum', 60)", "label": "", "id": "sumErrors" } ]
  ]
}

output sns_topic_error_count {
  value = [
    for queueName in var.sns_topics : [
      var.metric_namespace,
      local.sns_request_error_metric_name,
      "TopicName", queueName,
      {
        label: "${queueName} errors",
        stat: "Sum"
      }
    ]
  ]
}

# By TopicName / OperationName

output sns_topic_operation_name_request_count_search {
  value = [
    [ { "expression": "SEARCH('{${var.metric_namespace},TopicName,OperationName} MetricName=\"${local.sns_request_count_metric_name}\"', 'Sum', 60)", "label": "", "id": "sumRequests" } ]
  ]
}

output sns_topic_operation_name_request_count {
  value = [
    for queueOperationPair in setproduct(var.sns_topics, var.sns_operation_names) : [
      var.metric_namespace,
      local.sns_request_count_metric_name,
      "TopicName", queueOperationPair[0],
      "OperationName", queueOperationPair[1],
      {
        label: "${queueOperationPair[0]}/${queueOperationPair[1]} request count",
        stat: "Sum"
      }
    ]
  ]
}

output sns_topic_operation_name_message_count_search {
  value = [
    [ { "expression": "SEARCH('{${var.metric_namespace},TopicName,OperationName} MetricName=\"${local.sns_message_count_metric_name}\"', 'Sum', 60)", "label": "", "id": "sumMessages" } ]
  ]
}

output sns_topic_operation_name_message_count {
  value = [
    for queueOperationPair in setproduct(var.sns_topics, var.sns_operation_names) : [
      var.metric_namespace,
      local.sns_message_count_metric_name,
      "TopicName", queueOperationPair[0],
      "OperationName", queueOperationPair[1],
      {
        label: "${queueOperationPair[0]}/${queueOperationPair[1]} messages sent",
        stat: "Sum"
      }
    ]
  ]
}

output sns_topic_operation_name_request_duration_average_search {
  value = [
    [ { "expression": "SEARCH('{${var.metric_namespace},TopicName,OperationName} MetricName=\"${local.sns_request_duration_metric_name}\"', 'Average', 60)", "label": "", "id": "averageDuration" } ]
  ]
}

output sns_topic_operation_name_request_duration_average {
  value = [
    for queueOperationPair in setproduct(var.sns_topics, var.sns_operation_names) : [
      var.metric_namespace,
      local.sns_request_duration_metric_name,
      "TopicName", queueOperationPair[0],
      "OperationName", queueOperationPair[1],
      {
        label: "${queueOperationPair[0]}/${queueOperationPair[1]} duration average",
        stat: "Average"
      }
    ]
  ]
}

output sns_topic_operation_name_request_duration_p95_search {
  value = [
    [ { "expression": "SEARCH('{${var.metric_namespace},TopicName,OperationName} MetricName=\"${local.sns_request_duration_metric_name}\"', 'p95', 60)", "label": "", "id": "p95Duration" } ]
  ]
}

output sns_topic_operation_name_request_duration_p95 {
  value = [
    for queueOperationPair in setproduct(var.sns_topics, var.sns_operation_names) : [
      var.metric_namespace,
      local.sns_request_duration_metric_name,
      "TopicName", queueOperationPair[0],
      "OperationName", queueOperationPair[1],
      {
        label: "${queueOperationPair[0]}/${queueOperationPair[1]} duration p95",
        stat: "p95"
      }
    ]
  ]
}

output sns_topic_operation_name_timeout_count_search {
  value = [
    [ { "expression": "SEARCH('{${var.metric_namespace},TopicName,OperationName} MetricName=\"${local.sns_request_timeout_metric_name}\"', 'Sum', 60)", "label": "", "id": "sumTimeouts" } ]
  ]
}

output sns_topic_operation_name_timeout_count {
  value = [
    for queueOperationPair in setproduct(var.sns_topics, var.sns_operation_names) : [
      var.metric_namespace,
      local.sns_request_timeout_metric_name,
      "TopicName", queueOperationPair[0],
      "OperationName", queueOperationPair[1],
      {
        label: "${queueOperationPair[0]}/${queueOperationPair[1]} timeouts",
        stat: "Sum"
      }
    ]
  ]
}

output sns_topic_operation_name_error_count_search {
  value = [
    [ { "expression": "SEARCH('{${var.metric_namespace},TopicName,OperationName} MetricName=\"${local.sns_request_error_metric_name}\"', 'Sum', 60)", "label": "", "id": "sumErrors" } ]
  ]
}

output sns_topic_operation_error_count {
  value = [
    for queueOperationPair in setproduct(var.sns_topics, var.sns_operation_names) : [
      var.metric_namespace,
      local.sns_request_error_metric_name,
      "TopicName", queueOperationPair[0],
      "OperationName", queueOperationPair[1],
      {
        label: "${queueOperationPair[0]}/${queueOperationPair[1]} errors",
        stat: "Sum"
      }
    ]
  ]
}