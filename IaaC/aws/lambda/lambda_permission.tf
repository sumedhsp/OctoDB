resource "aws_lambda_permission" "tfer--0c07c415-c7f3-5c75-9d67-37c569ecc840" {
  action        = "lambda:InvokeFunction"
  function_name = "arn:aws:lambda:us-east-2:571600864139:function:generateUserTokens"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:us-east-2:571600864139:6b6ucoyz90/*/POST/generate_token"
  statement_id  = "0c07c415-c7f3-5c75-9d67-37c569ecc840"
}

resource "aws_lambda_permission" "tfer--358f2ee7-0800-52e3-881a-60d7a35d05f3" {
  action        = "lambda:InvokeFunction"
  function_name = "arn:aws:lambda:us-east-2:571600864139:function:handleQuery"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:us-east-2:571600864139:6b6ucoyz90/*/POST/query"
  statement_id  = "358f2ee7-0800-52e3-881a-60d7a35d05f3"
}

resource "aws_lambda_permission" "tfer--461d5555-27da-5d61-813d-e2eb9cc0fa69" {
  action        = "lambda:InvokeFunction"
  function_name = "arn:aws:lambda:us-east-2:571600864139:function:M0"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:us-east-2:571600864139:2dr3wn94t1/*/POST/migrate"
  statement_id  = "461d5555-27da-5d61-813d-e2eb9cc0fa69"
}

resource "aws_lambda_permission" "tfer--68b31cba-b7eb-59b2-aba5-a227f7fed785" {
  action        = "lambda:InvokeFunction"
  function_name = "arn:aws:lambda:us-east-2:571600864139:function:dashboard"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:us-east-2:571600864139:6b6ucoyz90/*/POST/dashboard"
  statement_id  = "68b31cba-b7eb-59b2-aba5-a227f7fed785"
}

resource "aws_lambda_permission" "tfer--97a8201a-376e-55f7-b3be-8d88894ce03c" {
  action        = "lambda:InvokeFunction"
  function_name = "arn:aws:lambda:us-east-2:571600864139:function:generateUserTokens"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:us-east-2:571600864139:2dr3wn94t1/*/POST/generate_token"
  statement_id  = "97a8201a-376e-55f7-b3be-8d88894ce03c"
}

resource "aws_lambda_permission" "tfer--AllowSelfInvoke" {
  action        = "lambda:InvokeFunction"
  function_name = "arn:aws:lambda:us-east-2:571600864139:function:testDbCreation"
  principal     = "lambda.amazonaws.com"
  statement_id  = "AllowSelfInvoke"
}

resource "aws_lambda_permission" "tfer--da6e1d35-e241-5bd7-9150-e44a01a179c8" {
  action        = "lambda:InvokeFunction"
  function_name = "arn:aws:lambda:us-east-2:571600864139:function:handleQuery"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:us-east-2:571600864139:2dr3wn94t1/*/POST/query"
  statement_id  = "da6e1d35-e241-5bd7-9150-e44a01a179c8"
}

resource "aws_lambda_permission" "tfer--dd4d318a-df64-5e0b-b004-9f8591fb5db8" {
  action        = "lambda:InvokeFunction"
  function_name = "arn:aws:lambda:us-east-2:571600864139:function:testFunction"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:us-east-2:571600864139:2dr3wn94t1/*/POST/create_user"
  statement_id  = "dd4d318a-df64-5e0b-b004-9f8591fb5db8"
}

resource "aws_lambda_permission" "tfer--eaf951cc-412e-5747-bc6e-9bd574525733" {
  action        = "lambda:InvokeFunction"
  function_name = "arn:aws:lambda:us-east-2:571600864139:function:validateUser"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:us-east-2:571600864139:2dr3wn94t1/*/POST/validate_user"
  statement_id  = "eaf951cc-412e-5747-bc6e-9bd574525733"
}

resource "aws_lambda_permission" "tfer--f2f708be-ef61-5079-b0b9-5cd60eb92368" {
  action        = "lambda:InvokeFunction"
  function_name = "arn:aws:lambda:us-east-2:571600864139:function:dashboard"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:us-east-2:571600864139:2dr3wn94t1/*/POST/dashboard"
  statement_id  = "f2f708be-ef61-5079-b0b9-5cd60eb92368"
}

resource "aws_lambda_permission" "tfer--f3d765fe-f959-5d08-baa5-e5615ac2c3f5" {
  action        = "lambda:InvokeFunction"
  function_name = "arn:aws:lambda:us-east-2:571600864139:function:authHandler"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:us-east-2:571600864139:2dr3wn94t1/authorizers/0w9k5i"
  statement_id  = "f3d765fe-f959-5d08-baa5-e5615ac2c3f5"
}
