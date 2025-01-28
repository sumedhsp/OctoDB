resource "aws_lambda_function_event_invoke_config" "tfer--feic_arn-003A-aws-003A-lambda-003A-us-east-2-003A-571600864139-003A-function-003A-M1-003A--0024-LATEST" {
  destination_config {
    on_failure {
      destination = "arn:aws:sqs:us-east-2:571600864139:log_queue"
    }
  }

  function_name          = "arn:aws:lambda:us-east-2:571600864139:function:M1"
  maximum_retry_attempts = "0"
}

resource "aws_lambda_function_event_invoke_config" "tfer--feic_arn-003A-aws-003A-lambda-003A-us-east-2-003A-571600864139-003A-function-003A-testDbCreation-003A--0024-LATEST" {
  destination_config {
    on_failure {
      destination = "arn:aws:sqs:us-east-2:571600864139:log_queue"
    }
  }

  function_name          = "arn:aws:lambda:us-east-2:571600864139:function:testDbCreation"
  maximum_retry_attempts = "0"
}
