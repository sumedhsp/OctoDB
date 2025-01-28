resource "aws_lambda_layer_version" "tfer--arn-003A-aws-003A-lambda-003A-us-east-2-003A-571600864139-003A-layer-003A-redis-layer-003A-1" {
  compatible_architectures = ["x86_64"]
  compatible_runtimes      = ["python3.13"]
  layer_name               = "redis-layer"
}

resource "aws_lambda_layer_version" "tfer--arn-003A-aws-003A-lambda-003A-us-east-2-003A-571600864139-003A-layer-003A-requests-lib-003A-1" {
  compatible_architectures = ["x86_64"]
  compatible_runtimes      = ["python3.13"]
  description              = "Requests library to send emails"
  layer_name               = "requests-lib"
}
