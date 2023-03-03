locals {
  graphql_request_count_metric_name = "graphql-request-count"
  graphql_request_duration_metric_name = "graphql-request-duration"
  graphql_request_timeout_metric_name = "graphql-request-timeout"
  graphql_request_error_metric_name = "graphql-request-error"
}

# No dimensions

output graphql_request_count {
  value = [
    [
      var.metric_namespace,
      local.graphql_request_count_metric_name,
      {
        label: "GraphQL request count",
        stat: "Sum"
      }
    ]
  ]
}

output graphql_request_duration_average {
  value = [
    [
      var.metric_namespace,
      local.graphql_request_duration_metric_name,
      {
        label: "GraphQL duration average",
        stat: "Average"
      }
    ]
  ]
}

output graphql_request_duration_p95 {
  value = [
    [
      var.metric_namespace,
      local.graphql_request_duration_metric_name,
      {
        label: "GraphQL duration p95",
        stat: "p95"
      }
    ]
  ]
}

output graphql_timeout_count {
  value = [
    [
      var.metric_namespace,
      local.graphql_request_timeout_metric_name,
      {
        label: "GraphQL timeouts",
        stat: "Sum"
      }
    ]
  ]
}

output graphql_error_count {
  value = [
    [
      var.metric_namespace,
      local.graphql_request_error_metric_name,
      {
        label: "GraphQL errors",
        stat: "Sum"
      }
    ]
  ]
}

# By OperationName

output graphql_operation_name_request_count_search {
  value = [
    [ { "expression": "SEARCH('{${var.metric_namespace},OperationName} MetricName=\"${local.graphql_request_count_metric_name}\"', 'Sum', 60)", "label": "", "id": "sumRequests" } ]
  ]
}

output graphql_operation_name_request_count {
  value = [
    for operationName in var.graphql_operation_names : [
      var.metric_namespace,
      local.graphql_request_count_metric_name,
      "OperationName", operationName,
      {
        label: "${operationName} request count",
        stat: "Sum"
      }
    ]
  ]
}

output graphql_operation_name_request_duration_average_search {
  value = [
    [ { "expression": "SEARCH('{${var.metric_namespace},OperationName} MetricName=\"${local.graphql_request_duration_metric_name}\"', 'Average', 60)", "label": "", "id": "averageDuration" } ]
  ]
}

output graphql_operation_name_request_duration_average {
  value = [
    for operationName in var.graphql_operation_names : [
      var.metric_namespace,
      local.graphql_request_duration_metric_name,
      "OperationName", operationName,
      {
        label: "${operationName} duration average",
        stat: "Average"
      }
    ]
  ]
}

output graphql_operation_name_request_duration_p95_search {
  value = [
    [ { "expression": "SEARCH('{${var.metric_namespace},OperationName} MetricName=\"${local.graphql_request_duration_metric_name}\"', 'p95', 60)", "label": "", "id": "p95Duration" } ]
  ]
}

output graphql_operation_name_request_duration_p95 {
  value = [
    for operationName in var.graphql_operation_names : [
      var.metric_namespace,
      local.graphql_request_duration_metric_name,
      "OperationName", operationName,
      {
        label: "${operationName} duration p95",
        stat: "p95"
      }
    ]
  ]
}

output graphql_operation_name_timeout_count_search {
  value = [
    [ { "expression": "SEARCH('{${var.metric_namespace},OperationName} MetricName=\"${local.graphql_request_timeout_metric_name}\"', 'Sum', 60)", "label": "", "id": "sumTimeouts" } ]
  ]
}

output graphql_operation_name_timeout_count {
  value = [
    for operationName in var.graphql_operation_names : [
      var.metric_namespace,
      local.graphql_request_timeout_metric_name,
      "OperationName", operationName,
      {
        label: "${operationName} timeouts",
        stat: "Sum"
      }
    ]
  ]
}

output graphql_operation_name_error_count_search {
  value = [
    [ { "expression": "SEARCH('{${var.metric_namespace},OperationName} MetricName=\"${local.graphql_request_error_metric_name}\"', 'Sum', 60)", "label": "", "id": "sumErrors" } ]
  ]
}

output graphql_operation_name_error_count {
  value = [
    for operationName in var.graphql_operation_names : [
      var.metric_namespace,
      local.graphql_request_error_metric_name,
      "OperationName", operationName,
      {
        label: "${operationName} errors",
        stat: "Sum"
      }
    ]
  ]
}
