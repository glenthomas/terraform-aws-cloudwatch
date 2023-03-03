locals {
  dynamodb_request_duration_metric_name = "dynamodb-request-duration"
  dynamodb_request_count_metric_name = "dynamodb-request-count"
  dynamodb_request_timeout_metric_name = "dynamodb-request-timeout"
  dynamodb_request_error_metric_name = "dynamodb-request-error"
}

# No dimensions

output dynamodb_request_count {
  value = [
    [
      var.metric_namespace,
      local.dynamodb_request_count_metric_name,
      {
        label: "DynamoDB request count",
        stat: "Sum"
      }
    ]
  ]
}

output dynamodb_request_duration_average {
  value = [
    [
      var.metric_namespace,
      local.dynamodb_request_duration_metric_name,
      {
        label: "DynamoDB duration average",
        stat: "Average"
      }
    ]
  ]
}

output dynamodb_request_duration_p95 {
  value = [
    [
      var.metric_namespace,
      local.dynamodb_request_duration_metric_name,
      {
        label: "DynamoDB duration p95",
        stat: "p95"
      }
    ]
  ]
}

output dynamodb_timeout_count {
  value = [
    [
      var.metric_namespace,
      local.dynamodb_request_timeout_metric_name,
      {
        label: "DynamoDB timeouts",
        stat: "Sum"
      }
    ]
  ]
}

output dynamodb_error_count {
  value = [
    [
      var.metric_namespace,
      local.dynamodb_request_error_metric_name,
      {
        label: "DynamoDB errors",
        stat: "Sum"
      }
    ]
  ]
}

# By TableName

output dynamodb_table_request_count_search {
  value = [
    [ { "expression": "SEARCH('{${var.metric_namespace},TableName} MetricName=\"${local.dynamodb_request_count_metric_name}\"', 'Sum', 60)", "label": "", "id": "e1" } ]
  ]
}

output dynamodb_table_request_count {
  value = [
    for tableName in var.dynamodb_tables : [
      var.metric_namespace,
      local.dynamodb_request_count_metric_name,
      "TableName", tableName,
      {
        label: "${tableName} request count",
        stat: "Sum"
      }
    ]
  ]
}

output dynamodb_table_request_duration_average_search {
  value = [
    [ { "expression": "SEARCH('{${var.metric_namespace},TableName} MetricName=\"${local.dynamodb_request_duration_metric_name}\"', 'Average', 60)", "label": "", "id": "e1" } ]
  ]
}

output dynamodb_table_request_duration_average {
  value = [
    for tableName in var.dynamodb_tables : [
      var.metric_namespace,
      local.dynamodb_request_duration_metric_name,
      "TableName", tableName,
      {
        label: "${tableName} duration average",
        stat: "Average"
      }
    ]
  ]
}

output dynamodb_table_request_duration_p95_search {
  value = [
    [ { "expression": "SEARCH('{${var.metric_namespace},TableName} MetricName=\"${local.dynamodb_request_duration_metric_name}\"', 'p95', 60)", "label": "", "id": "e1" } ]
  ]
}

output dynamodb_table_request_duration_p95 {
  value = [
    for tableName in var.dynamodb_tables : [
      var.metric_namespace,
      local.dynamodb_request_duration_metric_name,
      "TableName", tableName,
      {
        label: "${tableName} duration p95",
        stat: "p95"
      }
    ]
  ]
}

output dynamodb_table_timeout_count_search {
  value = [
    [ { "expression": "SEARCH('{${var.metric_namespace},TableName} MetricName=\"${local.dynamodb_request_timeout_metric_name}\"', 'Sum', 60)", "label": "", "id": "e1" } ]
  ]
}

output dynamodb_table_timeout_count {
  value = [
    for tableName in var.dynamodb_tables : [
      var.metric_namespace,
      local.dynamodb_request_timeout_metric_name,
      "TableName", tableName,
      {
        label: "${tableName} timeouts",
        stat: "Sum"
      }
    ]
  ]
}

output dynamodb_table_error_count_search {
  value = [
    [ { "expression": "SEARCH('{${var.metric_namespace},TableName} MetricName=\"${local.dynamodb_request_error_metric_name}\"', 'Sum', 60)", "label": "", "id": "e1" } ]
  ]
}

output dynamodb_table_error_count {
  value = [
    for tableName in var.dynamodb_tables : [
      var.metric_namespace,
      local.dynamodb_request_error_metric_name,
      "TableName", tableName,
      {
        label: "${tableName} errors",
        stat: "Sum"
      }
    ]
  ]
}

# By TableName / OperationName

output dynamodb_table_operation_name_request_count_search {
  value = [
    [ { "expression": "SEARCH('{${var.metric_namespace},TableName,OperationName} MetricName=\"${local.dynamodb_request_count_metric_name}\"', 'Sum', 60)", "label": "", "id": "e1" } ]
  ]
}

output dynamodb_table_operation_name_request_count {
  value = [
    for tableOperationPair in setproduct(var.dynamodb_tables, var.dynamodb_operation_names) : [
      var.metric_namespace,
      local.dynamodb_request_count_metric_name,
      "TableName", tableOperationPair[0],
      "OperationName", tableOperationPair[1],
      {
        label: "${tableOperationPair[0]}/${tableOperationPair[1]} request count",
        stat: "Sum"
      }
    ]
  ]
}

output dynamodb_table_operation_name_request_duration_average_search {
  value = [
    [ { "expression": "SEARCH('{${var.metric_namespace},TableName,OperationName} MetricName=\"${local.dynamodb_request_duration_metric_name}\"', 'Average', 60)", "label": "", "id": "e1" } ]
  ]
}

output dynamodb_table_operation_name_request_duration_average {
  value = [
    for tableOperationPair in setproduct(var.dynamodb_tables, var.dynamodb_operation_names) : [
      var.metric_namespace,
      local.dynamodb_request_duration_metric_name,
      "TableName", tableOperationPair[0],
      "OperationName", tableOperationPair[1],
      {
        label: "${tableOperationPair[0]}/${tableOperationPair[1]} duration average",
        stat: "Average"
      }
    ]
  ]
}

output dynamodb_table_operation_name_request_duration_p95_search {
  value = [
    [ { "expression": "SEARCH('{${var.metric_namespace},TableName,OperationName} MetricName=\"${local.dynamodb_request_duration_metric_name}\"', 'p95', 60)", "label": "", "id": "e1" } ]
  ]
}

output dynamodb_table_operation_name_request_duration_p95 {
  value = [
    for tableOperationPair in setproduct(var.dynamodb_tables, var.dynamodb_operation_names) : [
      var.metric_namespace,
      local.dynamodb_request_duration_metric_name,
      "TableName", tableOperationPair[0],
      "OperationName", tableOperationPair[1],
      {
        label: "${tableOperationPair[0]}/${tableOperationPair[1]} duration p95",
        stat: "p95"
      }
    ]
  ]
}

output dynamodb_table_operation_name_timeout_count_search {
  value = [
    [ { "expression": "SEARCH('{${var.metric_namespace},TableName,OperationName} MetricName=\"${local.dynamodb_request_timeout_metric_name}\"', 'Sum', 60)", "label": "", "id": "e1" } ]
  ]
}

output dynamodb_table_operation_name_timeout_count {
  value = [
    for tableOperationPair in setproduct(var.dynamodb_tables, var.dynamodb_operation_names) : [
      var.metric_namespace,
      local.dynamodb_request_timeout_metric_name,
      "TableName", tableOperationPair[0],
      "OperationName", tableOperationPair[1],
      {
        label: "${tableOperationPair[0]}/${tableOperationPair[1]} timeouts",
        stat: "Sum"
      }
    ]
  ]
}

output dynamodb_table_operation_name_error_count_search {
  value = [
    [ { "expression": "SEARCH('{${var.metric_namespace},TableName,OperationName} MetricName=\"${local.dynamodb_request_error_metric_name}\"', 'Sum', 60)", "label": "", "id": "e1" } ]
  ]
}

output dynamodb_table_operation_name_error_count {
  value = [
    for tableOperationPair in setproduct(var.dynamodb_tables, var.dynamodb_operation_names) : [
      var.metric_namespace,
      local.dynamodb_request_error_metric_name,
      "TableName", tableOperationPair[0],
      "OperationName", tableOperationPair[1],
      {
        label: "${tableOperationPair[0]}/${tableOperationPair[1]} errors",
        stat: "Sum"
      }
    ]
  ]
}