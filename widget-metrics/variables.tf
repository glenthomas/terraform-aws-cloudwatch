variable metric_namespace {
    type = string
}

variable http_services {
    type = list(string)
    default = []
}

variable http_hosts {
    type = list(string)
    default = []
}

variable http_operation_names {
    type = list(string)
    default = []
}

variable sqs_queues {
    type = list(string)
    default = []
}

variable sqs_operation_names {
    type = list(string)
    default = []
}

variable sqs_operation_types {
    type = list(string)
    default = [
        "CreateQueue",
        "DeleteMessage",
        "DeleteMessageBatch",
        "DeleteQueue",
        "ListQueues",
        "PurgeQueue",
        "SendMessage",
        "SendMessageBatch"
        ]
}

variable sns_topics {
    type = list(string)
    default = []
}

variable sns_operation_names {
    type = list(string)
    default = []
}

variable dynamodb_tables {
    type = list(string)
    default = []
}

variable dynamodb_operation_names {
    type = list(string)
    default = []
}

variable s3_buckets{
    type = list(string)
    default = []
}

variable s3_operation_names {
    type = list(string)
    default = []
}

variable s3_operation_types {
    type = list(string)
    default = [
        "CopyObject",
        "CreateBucket",
        "DeleteBucket",
        "DeleteObject",
        "DeleteObjects",
        "GetBucketPolicy",
        "GetObject",
        "GetSignedUrl",
        "HeadBucket",
        "ListBuckets",
        "ListObjects",
        "ListObjectsV2",
        "ListObjectVersions",
        "ListParts",
        "PutBucketPolicy",
        "PutObject",
        "RestoreObject",
        "Upload",
        "UploadPart"
        ]
}

variable graphql_operation_names {
    type = list(string)
    default = []
}