output "aws_sqs_queue_tfer--log_queue_arn" {
  value = "${aws_sqs_queue.tfer--log_queue.arn}"
}

output "aws_sqs_queue_tfer--log_queue_id" {
  value = "${aws_sqs_queue.tfer--log_queue.id}"
}

output "aws_sqs_queue_tfer--migrationQueue_arn" {
  value = "${aws_sqs_queue.tfer--migrationQueue.arn}"
}

output "aws_sqs_queue_tfer--migrationQueue_id" {
  value = "${aws_sqs_queue.tfer--migrationQueue.id}"
}
