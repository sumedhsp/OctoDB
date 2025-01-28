resource "aws_dynamodb_table" "tfer--db_metadata" {
  attribute {
    name = "db_id"
    type = "S"
  }

  billing_mode                = "PAY_PER_REQUEST"
  deletion_protection_enabled = "false"
  hash_key                    = "db_id"
  name                        = "db_metadata"

  point_in_time_recovery {
    enabled = "false"
  }

  read_capacity  = "0"
  stream_enabled = "false"
  table_class    = "STANDARD"
  write_capacity = "0"
}

resource "aws_dynamodb_table" "tfer--log_table" {
  attribute {
    name = "create_timestamp"
    type = "S"
  }

  attribute {
    name = "log_id"
    type = "S"
  }

  billing_mode                = "PAY_PER_REQUEST"
  deletion_protection_enabled = "false"
  hash_key                    = "log_id"
  name                        = "log_table"

  point_in_time_recovery {
    enabled = "false"
  }

  range_key      = "create_timestamp"
  read_capacity  = "0"
  stream_enabled = "false"
  table_class    = "STANDARD"
  write_capacity = "0"
}

resource "aws_dynamodb_table" "tfer--migration_status" {
  attribute {
    name = "id"
    type = "S"
  }

  billing_mode                = "PAY_PER_REQUEST"
  deletion_protection_enabled = "false"
  hash_key                    = "id"
  name                        = "migration_status"

  point_in_time_recovery {
    enabled = "false"
  }

  read_capacity  = "0"
  stream_enabled = "false"
  table_class    = "STANDARD"
  write_capacity = "0"
}

resource "aws_dynamodb_table" "tfer--query_logs" {
  attribute {
    name = "log_id"
    type = "S"
  }

  billing_mode                = "PAY_PER_REQUEST"
  deletion_protection_enabled = "false"
  hash_key                    = "log_id"
  name                        = "query_logs"

  point_in_time_recovery {
    enabled = "false"
  }

  read_capacity  = "0"
  stream_enabled = "false"
  table_class    = "STANDARD"
  write_capacity = "0"
}

resource "aws_dynamodb_table" "tfer--query_stats" {
  attribute {
    name = "db_id"
    type = "S"
  }

  billing_mode                = "PAY_PER_REQUEST"
  deletion_protection_enabled = "false"
  hash_key                    = "db_id"
  name                        = "query_stats"

  point_in_time_recovery {
    enabled = "false"
  }

  read_capacity  = "0"
  stream_enabled = "false"
  table_class    = "STANDARD"
  write_capacity = "0"
}

resource "aws_dynamodb_table" "tfer--table_metadata" {
  attribute {
    name = "table_id"
    type = "S"
  }

  billing_mode                = "PAY_PER_REQUEST"
  deletion_protection_enabled = "false"
  hash_key                    = "table_id"
  name                        = "table_metadata"

  point_in_time_recovery {
    enabled = "false"
  }

  read_capacity  = "0"
  stream_enabled = "false"
  table_class    = "STANDARD"
  write_capacity = "0"
}

resource "aws_dynamodb_table" "tfer--tenants" {
  attribute {
    name = "tenant_id"
    type = "S"
  }

  billing_mode                = "PAY_PER_REQUEST"
  deletion_protection_enabled = "false"
  hash_key                    = "tenant_id"
  name                        = "tenants"

  point_in_time_recovery {
    enabled = "false"
  }

  read_capacity  = "0"
  stream_enabled = "false"
  table_class    = "STANDARD"
  write_capacity = "0"
}
