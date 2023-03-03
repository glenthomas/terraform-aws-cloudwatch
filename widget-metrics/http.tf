locals {
  http_request_duration_metric_name = "http-request-duration"
  http_request_count_metric_name = "http-request-count"
  http_response_status_5xx_metric_name = "http-response-status-5xx"
  http_response_status_4xx_metric_name = "http-response-status-4xx"
  http_response_status_2xx_metric_name = "http-response-status-2xx"
  http_request_timeout_metric_name = "http-request-timeout"
}

# No dimensions

output http_request_count {
    value = [
        [
            var.metric_namespace,
            local.http_request_count_metric_name,
            {
                label: "HTTP request count",
                stat: "Sum"
            }
        ]
    ]
}

output http_duration_average {
    value = [
        [
            var.metric_namespace,
            local.http_request_duration_metric_name,
            {
                label: "HTTP duration average",
                stat: "Average"
            }
        ]
    ]
}

output http_duration_p95 {
    value = [
        [
            var.metric_namespace,
            local.http_request_duration_metric_name,
            {
                label: "HTTP duration p95",
                stat: "p95"
            }
        ]
    ]
}

output http_5xx_status_count {
    value = [
        [
            var.metric_namespace,
            local.http_response_status_5xx_metric_name,
            {
                label: "HTTP 5xx",
                stat: "Sum"
            }
        ]
    ]
}

output http_4xx_status_count {
    value = [
        [
            var.metric_namespace,
            local.http_response_status_4xx_metric_name,
            {
                label: "HTTP 4xx",
                stat: "Sum"
            }
        ]
    ]
}

output http_2xx_status_count {
    value = [
        [
            var.metric_namespace,
            local.http_response_status_2xx_metric_name,
            {
                label: "HTTP 2xx",
                stat: "Sum"
            }
        ]
    ]
}

output http_timeout_count {
    value = [
        [
            var.metric_namespace,
            local.http_request_timeout_metric_name,
            {
                label: "HTTP timeouts",
                stat: "Sum"
            }
        ]
    ]
}

# By Service

output http_service_request_count_search {
  value = [
    [ { "expression": "SEARCH('{${var.metric_namespace},Service} MetricName=\"${local.http_request_count_metric_name}\"', 'Sum', 60)", "label": "", "id": "sumRequests" } ]
  ]
}

output http_service_request_count {
    value = [
        for serviceName in var.http_services : [
            var.metric_namespace,
            local.http_request_count_metric_name,
            "Service", serviceName,
            {
                label: "${serviceName} request count",
                stat: "Sum"
            }
        ]
    ]
}

output http_service_duration_average_search {
  value = [
    [ { "expression": "SEARCH('{${var.metric_namespace},Service} MetricName=\"${local.http_request_duration_metric_name}\"', 'Average', 60)", "label": "", "id": "averageDuration" } ]
  ]
}

output http_service_duration_average {
    value = [
        for serviceName in var.http_services : [
            var.metric_namespace,
            local.http_request_duration_metric_name,
            "Service", serviceName,
            {
                label: "${serviceName} duration average",
                stat: "Average"
            }
        ]
    ]
}

output http_service_duration_p95_search {
  value = [
    [ { "expression": "SEARCH('{${var.metric_namespace},Service} MetricName=\"${local.http_request_duration_metric_name}\"', 'p95', 60)", "label": "", "id": "p95Duration" } ]
  ]
}

output http_service_duration_p95 {
    value = [
        for serviceName in var.http_services : [
            var.metric_namespace,
            local.http_request_duration_metric_name,
            "Service", serviceName,
            {
                label: "${serviceName} duration p95",
                stat: "p95"
            }
        ]
    ]
}

output http_service_5xx_status_count_search {
  value = [
    [ { "expression": "SEARCH('{${var.metric_namespace},Service} MetricName=\"${local.http_response_status_5xx_metric_name}\"', 'Sum', 60)", "label": "", "id": "sum5xx" } ]
  ]
}

output http_service_5xx_status_count {
    value = [
        for serviceName in var.http_services : [
            var.metric_namespace,
            local.http_response_status_5xx_metric_name,
            "Service", serviceName,
            {
                label: "${serviceName} 5xx",
                stat: "Sum"
            }
        ]
    ]
}

output http_service_4xx_status_count_search {
  value = [
    [ { "expression": "SEARCH('{${var.metric_namespace},Service} MetricName=\"${local.http_response_status_4xx_metric_name}\"', 'Sum', 60)", "label": "", "id": "sum4xx" } ]
  ]
}

output http_service_4xx_status_count {
    value = [
        for serviceName in var.http_services : [
            var.metric_namespace,
            local.http_response_status_4xx_metric_name,
            "Service", serviceName,
            {
                label: "${serviceName} 4xx",
                stat: "Sum"
            }
        ]
    ]
}

output http_service_2xx_status_count_search {
  value = [
    [ { "expression": "SEARCH('{${var.metric_namespace},Service} MetricName=\"${local.http_response_status_2xx_metric_name}\"', 'Sum', 60)", "label": "", "id": "sum2xx" } ]
  ]
}

output http_service_2xx_status_count {
    value = [
        for serviceName in var.http_services : [
            var.metric_namespace,
            local.http_response_status_2xx_metric_name,
            "Service", serviceName,
            {
                label: "${serviceName} 2xx",
                stat: "Sum"
            }
        ]
    ]
}

output http_service_timeout_count_search {
  value = [
    [ { "expression": "SEARCH('{${var.metric_namespace},Service} MetricName=\"${local.http_request_timeout_metric_name}\"', 'Sum', 60)", "label": "", "id": "sumTimeout" } ]
  ]
}

output http_service_timeout_count {
    value = [
        for serviceName in var.http_services : [
            var.metric_namespace,
            local.http_request_timeout_metric_name,
            "Service", serviceName,
            {
                label: "${serviceName} timeouts",
                stat: "Sum"
            }
        ]
    ]
}

# By Host

output http_host_request_count_search {
  value = [
    [ { "expression": "SEARCH('{${var.metric_namespace},Host} MetricName=\"${local.http_request_count_metric_name}\"', 'Sum', 60)", "label": "", "id": "sumRequests" } ]
  ]
}

output http_host_request_count {
    value = [
        for hostName in var.http_hosts : [
            var.metric_namespace,
            local.http_request_count_metric_name,
            "Host", hostName,
            {
                label: "${hostName} request count",
                stat: "Sum"
            }
        ]
    ]
}

output http_host_duration_average_search {
  value = [
    [ { "expression": "SEARCH('{${var.metric_namespace},Host} MetricName=\"${local.http_request_duration_metric_name}\"', 'Average', 60)", "label": "", "id": "averageDuration" } ]
  ]
}

output http_host_duration_average {
    value = [
        for hostName in var.http_hosts : [
            var.metric_namespace,
            local.http_request_duration_metric_name,
            "Host", hostName,
            {
                label: "${hostName} duration average",
                stat: "Average"
            }
        ]
    ]
}

output http_host_duration_p95_search {
  value = [
    [ { "expression": "SEARCH('{${var.metric_namespace},Host} MetricName=\"${local.http_request_duration_metric_name}\"', 'p95', 60)", "label": "", "id": "p95Duration" } ]
  ]
}

output http_host_duration_p95 {
    value = [
        for hostName in var.http_hosts : [
            var.metric_namespace,
            local.http_request_duration_metric_name,
            "Host", hostName,
            {
                label: "${hostName} duration p95",
                stat: "p95"
            }
        ]
    ]
}

output http_host_5xx_status_count_search {
  value = [
    [ { "expression": "SEARCH('{${var.metric_namespace},Host} MetricName=\"${local.http_response_status_5xx_metric_name}\"', 'Sum', 60)", "label": "", "id": "sum5xx" } ]
  ]
}

output http_host_5xx_status_count {
    value = [
        for hostName in var.http_hosts : [
            var.metric_namespace,
            local.http_response_status_5xx_metric_name,
            "Host", hostName,
            {
                label: "${hostName} 5xx",
                stat: "Sum"
            }
        ]
    ]
}

output http_host_4xx_status_count_search {
  value = [
    [ { "expression": "SEARCH('{${var.metric_namespace},Host} MetricName=\"${local.http_response_status_4xx_metric_name}\"', 'Sum', 60)", "label": "", "id": "sum4xx" } ]
  ]
}

output http_host_4xx_status_count {
    value = [
        for hostName in var.http_hosts : [
            var.metric_namespace,
            local.http_response_status_4xx_metric_name,
            "Host", hostName,
            {
                label: "${hostName} 4xx",
                stat: "Sum"
            }
        ]
    ]
}

output http_host_2xx_status_count_search {
  value = [
    [ { "expression": "SEARCH('{${var.metric_namespace},Host} MetricName=\"${local.http_response_status_2xx_metric_name}\"', 'Sum', 60)", "label": "", "id": "sum2xx" } ]
  ]
}

output http_host_2xx_status_count {
    value = [
        for hostName in var.http_hosts : [
            var.metric_namespace,
            local.http_response_status_2xx_metric_name,
            "Host", hostName,
            {
                label: "${hostName} 2xx",
                stat: "Sum"
            }
        ]
    ]
}

output http_host_timeout_count_search {
  value = [
    [ { "expression": "SEARCH('{${var.metric_namespace},Host} MetricName=\"${local.http_request_timeout_metric_name}\"', 'Sum', 60)", "label": "", "id": "sumTimeout" } ]
  ]
}

output http_host_timeout_count {
    value = [
        for hostName in var.http_hosts : [
            var.metric_namespace,
            local.http_request_timeout_metric_name,
            "Host", hostName,
            {
                label: "${hostName} timeouts",
                stat: "Sum"
            }
        ]
    ]
}

# By Operation

output http_operation_request_count_search {
  value = [
    [ { "expression": "SEARCH('{${var.metric_namespace},OperationName} MetricName=\"${local.http_request_count_metric_name}\"', 'Sum', 60)", "label": "", "id": "sumRequests" } ]
  ]
}

output http_operation_request_count {
    value = [
        for operationName in var.http_operation_names : [
            var.metric_namespace,
            local.http_request_count_metric_name,
            "OperationName", operationName,
            {
                label: "${operationName} request count",
                stat: "Sum"
            }
        ]
    ]
}

output http_operation_duration_average_search {
  value = [
    [ { "expression": "SEARCH('{${var.metric_namespace},OperationName} MetricName=\"${local.http_request_duration_metric_name}\"', 'Average', 60)", "label": "", "id": "averageDuration" } ]
  ]
}

output http_operation_duration_average {
    value = [
        for operationName in var.http_operation_names : [
            var.metric_namespace,
            local.http_request_duration_metric_name,
            "OperationName", operationName,
            {
                label: "${operationName} duration average",
                stat: "Average"
            }
        ]
    ]
}

output http_operation_duration_p95_search {
  value = [
    [ { "expression": "SEARCH('{${var.metric_namespace},OperationName} MetricName=\"${local.http_request_duration_metric_name}\"', 'p95', 60)", "label": "", "id": "p95Duration" } ]
  ]
}

output http_operation_duration_p95 {
    value = [
        for operationName in var.http_operation_names : [
            var.metric_namespace,
            local.http_request_duration_metric_name,
            "OperationName", operationName,
            {
                label: "${operationName} duration p95",
                stat: "p95"
            }
        ]
    ]
}

output http_operation_5xx_status_count_search {
  value = [
    [ { "expression": "SEARCH('{${var.metric_namespace},OperationName} MetricName=\"${local.http_response_status_5xx_metric_name}\"', 'Sum', 60)", "label": "", "id": "sum5xx" } ]
  ]
}

output http_operation_5xx_status_count {
    value = [
        for operationName in var.http_operation_names : [
            var.metric_namespace,
            local.http_response_status_5xx_metric_name,
            "OperationName", operationName,
            {
                label: "${operationName} 5xx",
                stat: "Sum"
            }
        ]
    ]
}

output http_operation_4xx_status_count_search {
  value = [
    [ { "expression": "SEARCH('{${var.metric_namespace},OperationName} MetricName=\"${local.http_response_status_4xx_metric_name}\"', 'Sum', 60)", "label": "", "id": "sum4xx" } ]
  ]
}

output http_operation_4xx_status_count {
    value = [
        for operationName in var.http_operation_names : [
            var.metric_namespace,
            local.http_response_status_4xx_metric_name,
            "OperationName", operationName,
            {
                label: "${operationName} 4xx",
                stat: "Sum"
            }
        ]
    ]
}

output http_operation_2xx_status_count_search {
  value = [
    [ { "expression": "SEARCH('{${var.metric_namespace},OperationName} MetricName=\"${local.http_response_status_2xx_metric_name}\"', 'Sum', 60)", "label": "", "id": "sum2xx" } ]
  ]
}

output http_operation_2xx_status_count {
    value = [
        for operationName in var.http_operation_names : [
            var.metric_namespace,
            local.http_response_status_2xx_metric_name,
            "OperationName", operationName,
            {
                label: "${operationName} 2xx",
                stat: "Sum"
            }
        ]
    ]
}

output http_operation_timeout_count_search {
  value = [
    [ { "expression": "SEARCH('{${var.metric_namespace},OperationName} MetricName=\"${local.http_request_timeout_metric_name}\"', 'Sum', 60)", "label": "", "id": "sumTimeout" } ]
  ]
}

output http_operation_timeout_count {
    value = [
        for operationName in var.http_operation_names : [
            var.metric_namespace,
            local.http_request_timeout_metric_name,
            "OperationName", operationName,
            {
                label: "${operationName} timeouts",
                stat: "Sum"
            }
        ]
    ]
}

# By Service / Operation

output http_service_operation_request_count_search {
  value = [
    [ { "expression": "SEARCH('{${var.metric_namespace},Service,OperationName} MetricName=\"${local.http_request_count_metric_name}\"', 'Sum', 60)", "label": "", "id": "sumRequests" } ]
  ]
}

output http_service_operation_request_count {
    value = [
        for serviceOperationPair in setproduct(var.http_services, var.http_operation_names) : [
            var.metric_namespace,
            local.http_request_count_metric_name,
            "Service", serviceOperationPair[0],
            "OperationName", serviceOperationPair[1],
            {
                label: "${serviceOperationPair[0]}/${serviceOperationPair[1]} request count",
                stat: "Sum"
            }
        ]
    ]
}

output http_service_operation_duration_average_search {
  value = [
    [ { "expression": "SEARCH('{${var.metric_namespace},Service,OperationName} MetricName=\"${local.http_request_duration_metric_name}\"', 'Average', 60)", "label": "", "id": "averageDuration" } ]
  ]
}

output http_service_operation_duration_average {
    value = [
        for serviceOperationPair in setproduct(var.http_services, var.http_operation_names) : [
            var.metric_namespace,
            local.http_request_duration_metric_name,
            "Service", serviceOperationPair[0],
            "OperationName", serviceOperationPair[1],
            {
                label: "${serviceOperationPair[0]}/${serviceOperationPair[1]} duration average",
                stat: "Average"
            }
        ]
    ]
}

output http_service_operation_duration_p95_search {
  value = [
    [ { "expression": "SEARCH('{${var.metric_namespace},Service,OperationName} MetricName=\"${local.http_request_duration_metric_name}\"', 'p95', 60)", "label": "", "id": "p95Duration" } ]
  ]
}

output http_service_operation_duration_p95 {
    value = [
        for serviceOperationPair in setproduct(var.http_services, var.http_operation_names) : [
            var.metric_namespace,
            local.http_request_duration_metric_name,
            "Service", serviceOperationPair[0],
            "OperationName", serviceOperationPair[1],
            {
                label: "${serviceOperationPair[0]}/${serviceOperationPair[1]} duration p95",
                stat: "p95"
            }
        ]
    ]
}

output http_service_operation_5xx_status_count_search {
  value = [
    [ { "expression": "SEARCH('{${var.metric_namespace},Service,OperationName} MetricName=\"${local.http_response_status_5xx_metric_name}\"', 'Sum', 60)", "label": "", "id": "sum5xx" } ]
  ]
}

output http_service_operation_5xx_status_count {
    value = [
        for serviceOperationPair in setproduct(var.http_services, var.http_operation_names) : [
            var.metric_namespace,
            local.http_response_status_5xx_metric_name,
            "Service", serviceOperationPair[0],
            "OperationName", serviceOperationPair[1],
            {
                label: "${serviceOperationPair[0]}/${serviceOperationPair[1]} 5xx",
                stat: "Sum"
            }
        ]
    ]
}

output http_service_operation_4xx_status_count_search {
  value = [
    [ { "expression": "SEARCH('{${var.metric_namespace},Service,OperationName} MetricName=\"${local.http_response_status_4xx_metric_name}\"', 'Sum', 60)", "label": "", "id": "sum4xx" } ]
  ]
}

output http_service_operation_4xx_status_count {
    value = [
        for serviceOperationPair in setproduct(var.http_services, var.http_operation_names) : [
            var.metric_namespace,
            local.http_response_status_4xx_metric_name,
            "Service", serviceOperationPair[0],
            "OperationName", serviceOperationPair[1],
            {
                label: "${serviceOperationPair[0]}/${serviceOperationPair[1]} 4xx",
                stat: "Sum"
            }
        ]
    ]
}

output http_service_operation_2xx_status_count_search {
  value = [
    [ { "expression": "SEARCH('{${var.metric_namespace},Service,OperationName} MetricName=\"${local.http_response_status_2xx_metric_name}\"', 'Sum', 60)", "label": "", "id": "sum2xx" } ]
  ]
}

output http_service_operation_2xx_status_count {
    value = [
        for serviceOperationPair in setproduct(var.http_services, var.http_operation_names) : [
            var.metric_namespace,
            local.http_response_status_2xx_metric_name,
            "Service", serviceOperationPair[0],
            "OperationName", serviceOperationPair[1],
            {
                label: "${serviceOperationPair[0]}/${serviceOperationPair[1]} 2xx",
                stat: "Sum"
            }
        ]
    ]
}

output http_service_operation_timeout_count_search {
  value = [
    [ { "expression": "SEARCH('{${var.metric_namespace},Service,OperationName} MetricName=\"${local.http_request_timeout_metric_name}\"', 'Sum', 60)", "label": "", "id": "sumTimeout" } ]
  ]
}

output http_service_operation_timeout_count {
    value = [
        for serviceOperationPair in setproduct(var.http_services, var.http_operation_names) : [
            var.metric_namespace,
            local.http_request_timeout_metric_name,
            "Service", serviceOperationPair[0],
            "OperationName", serviceOperationPair[1],
            {
                label: "${serviceOperationPair[0]}/${serviceOperationPair[1]} timeouts",
                stat: "Sum"
            }
        ]
    ]
}