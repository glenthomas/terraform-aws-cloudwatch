locals {
  s3_request_count_metric_name = "s3-request-count"
  s3_request_duration_metric_name = "s3-request-duration"
  s3_request_timeout_metric_name = "s3-request-timeout"
  s3_request_error_metric_name = "s3-request-error"
}

# No dimensions

output s3_request_count {
  value = [
    [
      var.metric_namespace,
      local.s3_request_count_metric_name,
      {
        label: "S3 request count",
        stat: "Sum"
      }
    ]
  ]
}

output s3_request_duration_average {
  value = [
    [
      var.metric_namespace,
      local.s3_request_duration_metric_name,
      {
        label: "S3 duration average",
        stat: "Average"
      }
    ]
  ]
}

output s3_request_duration_p95 {
  value = [
    [
      var.metric_namespace,
      local.s3_request_duration_metric_name,
      {
        label: "S3 duration p95",
        stat: "p95"
      }
    ]
  ]
}

output s3_timeout_count {
  value = [
    [
      var.metric_namespace,
      local.s3_request_timeout_metric_name,
      {
        label: "S3 timeouts",
        stat: "Sum"
      }
    ]
  ]
}

output s3_error_count {
  value = [
    [
      var.metric_namespace,
      local.s3_request_error_metric_name,
      {
        label: "S3 errors",
        stat: "Sum"
      }
    ]
  ]
}

# By BucketName

output s3_bucket_request_count_search {
  value = [
    [ { "expression": "SEARCH('{${var.metric_namespace},BucketName} MetricName=\"${local.s3_request_count_metric_name}\"', 'Sum', 60)", "label": "", "id": "sumRequests" } ]
  ]
}

output s3_bucket_request_count {
  value = [
    for bucketName in var.s3_buckets : [
      var.metric_namespace,
      local.s3_request_count_metric_name,
      "BucketName", bucketName,
      {
        label: "${bucketName} request count",
        stat: "Sum"
      }
    ]
  ]
}

output s3_bucket_request_duration_average_search {
  value = [
    [ { "expression": "SEARCH('{${var.metric_namespace},BucketName} MetricName=\"${local.s3_request_duration_metric_name}\"', 'Average', 60)", "label": "", "id": "averageDuration" } ]
  ]
}

output s3_bucket_request_duration_average {
  value = [
    for bucketName in var.s3_buckets : [
      var.metric_namespace,
      local.s3_request_duration_metric_name,
      "BucketName", bucketName,
      {
        label: "${bucketName} duration average",
        stat: "Average"
      }
    ]
  ]
}

output s3_bucket_request_duration_p95_search {
  value = [
    [ { "expression": "SEARCH('{${var.metric_namespace},BucketName} MetricName=\"${local.s3_request_duration_metric_name}\"', 'p95', 60)", "label": "", "id": "p95Duration" } ]
  ]
}

output s3_bucket_request_duration_p95 {
  value = [
    for bucketName in var.s3_buckets : [
      var.metric_namespace,
      local.s3_request_duration_metric_name,
      "BucketName", bucketName,
      {
        label: "${bucketName} duration p95",
        stat: "p95"
      }
    ]
  ]
}

output s3_bucket_timeout_count_search {
  value = [
    [ { "expression": "SEARCH('{${var.metric_namespace},BucketName} MetricName=\"${local.s3_request_timeout_metric_name}\"', 'Sum', 60)", "label": "", "id": "sumTimeouts" } ]
  ]
}

output s3_bucket_timeout_count {
  value = [
    for bucketName in var.s3_buckets : [
      var.metric_namespace,
      local.s3_request_timeout_metric_name,
      "BucketName", bucketName,
      {
        label: "${bucketName} timeouts",
        stat: "Sum"
      }
    ]
  ]
}

output s3_bucket_error_count_search {
  value = [
    [ { "expression": "SEARCH('{${var.metric_namespace},BucketName} MetricName=\"${local.s3_request_error_metric_name}\"', 'Sum', 60)", "label": "", "id": "sumErrors" } ]
  ]
}

output s3_bucket_error_count {
  value = [
    for bucketName in var.s3_buckets : [
      var.metric_namespace,
      local.s3_request_error_metric_name,
      "BucketName", bucketName,
      {
        label: "${bucketName} errors",
        stat: "Sum"
      }
    ]
  ]
}

# By BucketName / OperationName

output s3_bucket_operation_name_request_count_search {
  value = [
    [ { "expression": "SEARCH('{${var.metric_namespace},BucketName} MetricName=\"${local.s3_request_count_metric_name}\"', 'Sum', 60)", "label": "", "id": "sumRequests" } ]
  ]
}

output s3_bucket_operation_name_request_count {
  value = [
    for bucketOperationPair in setproduct(var.s3_buckets, var.s3_operation_names) : [
      var.metric_namespace,
      local.s3_request_count_metric_name,
      "BucketName", bucketOperationPair[0],
      "OperationName", bucketOperationPair[1],
      {
        label: "${bucketOperationPair[0]}/${bucketOperationPair[1]} request count",
        stat: "Sum"
      }
    ]
  ]
}

output s3_bucket_operation_name_request_duration_average_search {
  value = [
    [ { "expression": "SEARCH('{${var.metric_namespace},BucketName,OperationName} MetricName=\"${local.s3_request_duration_metric_name}\"', 'Average', 60)", "label": "", "id": "averageDuration" } ]
  ]
}

output s3_bucket_operation_name_request_duration_average {
  value = [
    for bucketOperationPair in setproduct(var.s3_buckets, var.s3_operation_names) : [
      var.metric_namespace,
      local.s3_request_duration_metric_name,
      "BucketName", bucketOperationPair[0],
      "OperationName", bucketOperationPair[1],
      {
        label: "${bucketOperationPair[0]}/${bucketOperationPair[1]} duration average",
        stat: "Average"
      }
    ]
  ]
}

output s3_bucket_operation_name_request_duration_p95_search {
  value = [
    [ { "expression": "SEARCH('{${var.metric_namespace},BucketName,OperationName} MetricName=\"${local.s3_request_duration_metric_name}\"', 'p95', 60)", "label": "", "id": "p95Duration" } ]
  ]
}

output s3_bucket_operation_name_request_duration_p95 {
  value = [
    for bucketOperationPair in setproduct(var.s3_buckets, var.s3_operation_names) : [
      var.metric_namespace,
      local.s3_request_duration_metric_name,
      "BucketName", bucketOperationPair[0],
      "OperationName", bucketOperationPair[1],
      {
        label: "${bucketOperationPair[0]}/${bucketOperationPair[1]} duration p95",
        stat: "p95"
      }
    ]
  ]
}

output s3_bucket_operation_name_timeout_count_search {
  value = [
    [ { "expression": "SEARCH('{${var.metric_namespace},BucketName,OperationName} MetricName=\"${local.s3_request_timeout_metric_name}\"', 'Sum', 60)", "label": "", "id": "sumTimeouts" } ]
  ]
}

output s3_bucket_operation_name_timeout_count {
  value = [
    for bucketOperationPair in setproduct(var.s3_buckets, var.s3_operation_names) : [
      var.metric_namespace,
      local.s3_request_timeout_metric_name,
      "BucketName", bucketOperationPair[0],
      "OperationName", bucketOperationPair[1],
      {
        label: "${bucketOperationPair[0]}/${bucketOperationPair[1]} timeouts",
        stat: "Sum"
      }
    ]
  ]
}

output s3_bucket_operation_name_error_count_search {
  value = [
    [ { "expression": "SEARCH('{${var.metric_namespace},BucketName,OperationName} MetricName=\"${local.s3_request_error_metric_name}\"', 'Sum', 60)", "label": "", "id": "sumErrors" } ]
  ]
}

output s3_bucket_operation_name_error_count {
  value = [
    for bucketOperationPair in setproduct(var.s3_buckets, var.s3_operation_names) : [
      var.metric_namespace,
      local.s3_request_error_metric_name,
      "BucketName", bucketOperationPair[0],
      "OperationName", bucketOperationPair[1],
      {
        label: "${bucketOperationPair[0]}/${bucketOperationPair[1]} errors",
        stat: "Sum"
      }
    ]
  ]
}

# By BucketName / OperationType

output s3_bucket_operation_type_request_count_search {
  value = [
    [ { "expression": "SEARCH('{${var.metric_namespace},BucketName,OperationType} MetricName=\"${local.s3_request_count_metric_name}\"', 'Sum', 60)", "label": "", "id": "sumRequests" } ]
  ]
}

output s3_bucket_operation_type_request_count {
  value = [
    for bucketOperationPair in setproduct(var.s3_buckets, var.s3_operation_types) : [
      var.metric_namespace,
      local.s3_request_count_metric_name,
      "BucketName", bucketOperationPair[0],
      "OperationType", bucketOperationPair[1],
      {
        label: "${bucketOperationPair[0]}/${bucketOperationPair[1]} request count",
        stat: "Sum"
      }
    ]
  ]
}

output s3_bucket_operation_type_request_duration_average_search {
  value = [
    [ { "expression": "SEARCH('{${var.metric_namespace},BucketName,OperationType} MetricName=\"${local.s3_request_duration_metric_name}\"', 'Average', 60)", "label": "", "id": "averageDuration" } ]
  ]
}

output s3_bucket_operation_type_request_duration_average {
  value = [
    for bucketOperationPair in setproduct(var.s3_buckets, var.s3_operation_types) : [
      var.metric_namespace,
      local.s3_request_duration_metric_name,
      "BucketName", bucketOperationPair[0],
      "OperationType", bucketOperationPair[1],
      {
        label: "${bucketOperationPair[0]}/${bucketOperationPair[1]} duration average",
        stat: "Average"
      }
    ]
  ]
}

output s3_bucket_operation_type_request_duration_p95_search {
  value = [
    [ { "expression": "SEARCH('{${var.metric_namespace},BucketName,OperationType} MetricName=\"${local.s3_request_duration_metric_name}\"', 'p95', 60)", "label": "", "id": "p95Duration" } ]
  ]
}

output s3_bucket_operation_type_request_duration_p95 {
  value = [
    for bucketOperationPair in setproduct(var.s3_buckets, var.s3_operation_types) : [
      var.metric_namespace,
      local.s3_request_duration_metric_name,
      "BucketName", bucketOperationPair[0],
      "OperationType", bucketOperationPair[1],
      {
        label: "${bucketOperationPair[0]}/${bucketOperationPair[1]} duration p95",
        stat: "p95"
      }
    ]
  ]
}

output s3_bucket_operation_type_timeout_count_search {
  value = [
    [ { "expression": "SEARCH('{${var.metric_namespace},BucketName,OperationType} MetricName=\"${local.s3_request_timeout_metric_name}\"', 'Sum', 60)", "label": "", "id": "sumTimeouts" } ]
  ]
}

output s3_bucket_operation_type_timeout_count {
  value = [
    for bucketOperationPair in setproduct(var.s3_buckets, var.s3_operation_types) : [
      var.metric_namespace,
      local.s3_request_timeout_metric_name,
      "BucketName", bucketOperationPair[0],
      "OperationType", bucketOperationPair[1],
      {
        label: "${bucketOperationPair[0]}/${bucketOperationPair[1]} timeouts",
        stat: "Sum"
      }
    ]
  ]
}

output s3_bucket_operation_type_error_count_search {
  value = [
    [ { "expression": "SEARCH('{${var.metric_namespace},BucketName,OperationType} MetricName=\"${local.s3_request_error_metric_name}\"', 'Sum', 60)", "label": "", "id": "sumErrors" } ]
  ]
}

output s3_bucket_operation_type_error_count {
  value = [
    for bucketOperationPair in setproduct(var.s3_buckets, var.s3_operation_types) : [
      var.metric_namespace,
      local.s3_request_error_metric_name,
      "BucketName", bucketOperationPair[0],
      "OperationType", bucketOperationPair[1],
      {
        label: "${bucketOperationPair[0]}/${bucketOperationPair[1]} errors",
        stat: "Sum"
      }
    ]
  ]
}