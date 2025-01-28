output "aws_dynamodb_table_tfer--db_metadata_id" {
  value = "${aws_dynamodb_table.tfer--db_metadata.id}"
}

output "aws_dynamodb_table_tfer--log_table_id" {
  value = "${aws_dynamodb_table.tfer--log_table.id}"
}

output "aws_dynamodb_table_tfer--migration_status_id" {
  value = "${aws_dynamodb_table.tfer--migration_status.id}"
}

output "aws_dynamodb_table_tfer--query_logs_id" {
  value = "${aws_dynamodb_table.tfer--query_logs.id}"
}

output "aws_dynamodb_table_tfer--query_stats_id" {
  value = "${aws_dynamodb_table.tfer--query_stats.id}"
}

output "aws_dynamodb_table_tfer--table_metadata_id" {
  value = "${aws_dynamodb_table.tfer--table_metadata.id}"
}

output "aws_dynamodb_table_tfer--tenants_id" {
  value = "${aws_dynamodb_table.tfer--tenants.id}"
}
