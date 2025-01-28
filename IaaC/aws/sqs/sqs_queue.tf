resource "aws_sqs_queue" "tfer--log_queue" {
  content_based_deduplication       = "false"
  delay_seconds                     = "0"
  fifo_queue                        = "false"
  kms_data_key_reuse_period_seconds = "300"
  max_message_size                  = "262144"
  message_retention_seconds         = "345600"
  name                              = "log_queue"

  policy = <<POLICY
{
  "Id": "__default_policy_ID",
  "Statement": [
    {
      "Action": "SQS:*",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::571600864139:root"
      },
      "Resource": "arn:aws:sqs:us-east-2:571600864139:log_queue",
      "Sid": "__owner_statement"
    }
  ],
  "Version": "2012-10-17"
}
POLICY

  receive_wait_time_seconds  = "0"
  sqs_managed_sse_enabled    = "true"
  visibility_timeout_seconds = "630"
}

resource "aws_sqs_queue" "tfer--migrationQueue" {
  content_based_deduplication       = "false"
  delay_seconds                     = "0"
  fifo_queue                        = "false"
  kms_data_key_reuse_period_seconds = "300"
  max_message_size                  = "262144"
  message_retention_seconds         = "345600"
  name                              = "migrationQueue"

  policy = <<POLICY
{
  "Id": "__default_policy_ID",
  "Statement": [
    {
      "Action": "SQS:*",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::571600864139:root"
      },
      "Resource": "arn:aws:sqs:us-east-2:571600864139:migrationQueue",
      "Sid": "__owner_statement"
    },
    {
      "Action": "SQS:SendMessage",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::571600864139:user/naveenforcloudproject"
      },
      "Resource": "arn:aws:sqs:us-east-2:571600864139:migrationQueue",
      "Sid": "__sender_statement"
    },
    {
      "Action": [
        "SQS:ChangeMessageVisibility",
        "SQS:DeleteMessage",
        "SQS:ReceiveMessage"
      ],
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::571600864139:user/naveenforcloudproject"
      },
      "Resource": "arn:aws:sqs:us-east-2:571600864139:migrationQueue",
      "Sid": "__receiver_statement"
    }
  ],
  "Version": "2012-10-17"
}
POLICY

  receive_wait_time_seconds = "0"
  sqs_managed_sse_enabled   = "true"

  tags = {
    migrationQueue = "SQSQueue1"
  }

  tags_all = {
    migrationQueue = "SQSQueue1"
  }

  visibility_timeout_seconds = "30"
}
