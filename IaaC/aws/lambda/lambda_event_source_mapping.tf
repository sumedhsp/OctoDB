resource "aws_lambda_event_source_mapping" "tfer--0faa539a-798a-45ea-9bc4-36b328e56ea5" {
  batch_size                         = "10"
  bisect_batch_on_function_error     = "false"
  enabled                            = "true"
  event_source_arn                   = "arn:aws:sqs:us-east-2:571600864139:log_queue"
  function_name                      = "arn:aws:lambda:us-east-2:571600864139:function:L1_LogsProcessing"
  maximum_batching_window_in_seconds = "0"
  maximum_record_age_in_seconds      = "60"
  maximum_retry_attempts             = "0"
  parallelization_factor             = "1"
  tumbling_window_in_seconds         = "0"
}
