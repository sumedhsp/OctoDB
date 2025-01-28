resource "aws_lambda_function" "tfer--L1_LogsProcessing" {
  architectures = ["x86_64"]

  ephemeral_storage {
    size = "512"
  }

  function_name = "L1_LogsProcessing"
  handler       = "lambda_function.lambda_handler"

  logging_config {
    log_format = "Text"
    log_group  = "/aws/lambda/L1_LogsProcessing"
  }

  memory_size                    = "128"
  package_type                   = "Zip"
  reserved_concurrent_executions = "-1"
  role                           = "arn:aws:iam::571600864139:role/service-role/L1_LogsProcessing-role-9poh4pl6"
  runtime                        = "python3.13"
  skip_destroy                   = "false"
  timeout                        = "303"

  tracing_config {
    mode = "PassThrough"
  }
  filename                       = "function.zip"
  lifecycle {
    ignore_changes = [filename]
  }
}

resource "aws_lambda_function" "tfer--M0" {
  architectures = ["x86_64"]

  ephemeral_storage {
    size = "512"
  }

  function_name = "M0"
  handler       = "lambda_function.lambda_handler"
  layers        = ["arn:aws:lambda:us-east-2:571600864139:layer:redis-layer:1"]

  logging_config {
    log_format = "Text"
    log_group  = "/aws/lambda/M0"
  }

  memory_size                    = "128"
  package_type                   = "Zip"
  reserved_concurrent_executions = "-1"
  role                           = "arn:aws:iam::571600864139:role/service-role/M0-role-aox0rhci"
  runtime                        = "python3.13"
  skip_destroy                   = "false"
  timeout                        = "300"

  tracing_config {
    mode = "PassThrough"
  }
  filename                       = "function.zip"
  lifecycle {
    ignore_changes = [filename]
  }
}

resource "aws_lambda_function" "tfer--M1" {
  architectures = ["x86_64"]

  ephemeral_storage {
    size = "512"
  }

  function_name = "M1"
  handler       = "lambda_function.lambda_handler"
  layers        = ["arn:aws:lambda:us-east-2:571600864139:layer:redis-layer:1", "arn:aws:lambda:us-east-2:571600864139:layer:requests-lib:1"]

  logging_config {
    log_format = "Text"
    log_group  = "/aws/lambda/M1"
  }

  memory_size                    = "128"
  package_type                   = "Zip"
  reserved_concurrent_executions = "-1"
  role                           = "arn:aws:iam::571600864139:role/service-role/M1-role-xiyfas82"
  runtime                        = "python3.13"
  skip_destroy                   = "false"
  timeout                        = "600"

  tracing_config {
    mode = "PassThrough"
  }
  filename                       = "function.zip"
  lifecycle {
    ignore_changes = [filename]
  }
}

resource "aws_lambda_function" "tfer--authHandler" {
  architectures = ["x86_64"]
  description   = "LF0"

  ephemeral_storage {
    size = "512"
  }

  function_name = "authHandler"
  handler       = "lambda_function.lambda_handler"

  logging_config {
    log_format = "Text"
    log_group  = "/aws/lambda/authHandler"
  }

  memory_size                    = "128"
  package_type                   = "Zip"
  reserved_concurrent_executions = "-1"
  role                           = "arn:aws:iam::571600864139:role/service-role/authHandler-role-frn4akrh"
  runtime                        = "python3.13"
  skip_destroy                   = "false"
  timeout                        = "300"

  tracing_config {
    mode = "PassThrough"
  }
  
  filename                       = "function.zip"
  lifecycle {
    ignore_changes = [filename]
  }
}

resource "aws_lambda_function" "tfer--dashboard" {
  architectures = ["x86_64"]
  description   = "LF4"

  ephemeral_storage {
    size = "512"
  }

  function_name = "dashboard"
  handler       = "lambda_function.lambda_handler"

  logging_config {
    log_format = "Text"
    log_group  = "/aws/lambda/dashboard"
  }

  memory_size                    = "128"
  package_type                   = "Zip"
  reserved_concurrent_executions = "-1"
  role                           = "arn:aws:iam::571600864139:role/service-role/dashboard-role-gor4riai"
  runtime                        = "python3.13"
  skip_destroy                   = "false"
  timeout                        = "3"

  tracing_config {
    mode = "PassThrough"
  }

  filename                       = "function.zip"
  lifecycle {
    ignore_changes = [filename]
  }
}

resource "aws_lambda_function" "tfer--generateUserTokens" {
  architectures = ["x86_64"]
  description   = "Generate Auth Token"

  ephemeral_storage {
    size = "512"
  }

  function_name = "generateUserTokens"
  handler       = "lambda_function.lambda_handler"

  logging_config {
    log_format = "Text"
    log_group  = "/aws/lambda/generateUserTokens"
  }

  memory_size                    = "128"
  package_type                   = "Zip"
  reserved_concurrent_executions = "-1"
  role                           = "arn:aws:iam::571600864139:role/service-role/generateUserTokens-role-mo0yzvsg"
  runtime                        = "python3.13"
  skip_destroy                   = "false"
  timeout                        = "3"

  tracing_config {
    mode = "PassThrough"
  }
  
  filename                       = "function.zip"
  lifecycle {
    ignore_changes = [filename]
  }
}

resource "aws_lambda_function" "tfer--handleQuery" {
  architectures = ["x86_64"]
  description   = "LF2"

  ephemeral_storage {
    size = "512"
  }

  function_name = "handleQuery"
  handler       = "lambda_function.lambda_handler"

  logging_config {
    log_format = "Text"
    log_group  = "/aws/lambda/handleQuery"
  }

  memory_size                    = "128"
  package_type                   = "Zip"
  reserved_concurrent_executions = "-1"
  role                           = "arn:aws:iam::571600864139:role/service-role/handleQuery-role-6e09cwve"
  runtime                        = "python3.13"
  skip_destroy                   = "false"
  timeout                        = "20"

  tracing_config {
    mode = "PassThrough"
  }

  filename                       = "function.zip"
  lifecycle {
    ignore_changes = [filename]
  }
  
}

resource "aws_lambda_function" "tfer--testDbCreation" {
  architectures = ["x86_64"]
  description   = "LF6"

  ephemeral_storage {
    size = "512"
  }

  function_name = "testDbCreation"
  handler       = "lambda_function.lambda_handler"

  logging_config {
    log_format = "Text"
    log_group  = "/aws/lambda/testDbCreation"
  }

  memory_size                    = "128"
  package_type                   = "Zip"
  reserved_concurrent_executions = "-1"
  role                           = "arn:aws:iam::571600864139:role/service-role/testDbCreation-role-jbqi5p81"
  runtime                        = "python3.12"
  skip_destroy                   = "false"
  timeout                        = "30"

  tracing_config {
    mode = "PassThrough"
  }

  filename                       = "function.zip"
  lifecycle {
    ignore_changes = [filename]
  }
}

resource "aws_lambda_function" "tfer--testFunction" {
  architectures = ["x86_64"]
  description   = "LF3 - User Creation"

  ephemeral_storage {
    size = "512"
  }

  function_name = "testFunction"
  handler       = "lambda_function.lambda_handler"

  logging_config {
    log_format = "Text"
    log_group  = "/aws/lambda/testFunction"
  }

  memory_size                    = "128"
  package_type                   = "Zip"
  reserved_concurrent_executions = "-1"
  role                           = "arn:aws:iam::571600864139:role/service-role/testFunction-role-r0kevvjk"
  runtime                        = "python3.12"
  skip_destroy                   = "false"
  timeout                        = "300"

  tracing_config {
    mode = "PassThrough"
  }

  filename                       = "function.zip"
  lifecycle {
    ignore_changes = [filename]
  }
}

resource "aws_lambda_function" "tfer--validateUser" {
  architectures = ["x86_64"]

  ephemeral_storage {
    size = "512"
  }

  function_name = "validateUser"
  handler       = "lambda_function.lambda_handler"

  logging_config {
    log_format = "Text"
    log_group  = "/aws/lambda/validateUser"
  }

  memory_size                    = "128"
  package_type                   = "Zip"
  reserved_concurrent_executions = "-1"
  role                           = "arn:aws:iam::571600864139:role/service-role/validateUser-role-vbjiog7k"
  runtime                        = "python3.13"
  skip_destroy                   = "false"
  timeout                        = "3"

  tracing_config {
    mode = "PassThrough"
  }

  filename                       = "function.zip"
  lifecycle {
    ignore_changes = [filename]
  }
}
