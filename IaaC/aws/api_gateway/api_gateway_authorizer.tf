resource "aws_api_gateway_authorizer" "tfer--0w9k5i" {
  authorizer_result_ttl_in_seconds = "0"
  authorizer_uri                   = "arn:aws:apigateway:us-east-2:lambda:path/2015-03-31/functions/arn:aws:lambda:us-east-2:571600864139:function:authHandler/invocations"
  identity_source                  = "method.request.header.authToken"
  name                             = "LF0"
  rest_api_id                      = "2dr3wn94t1"
  type                             = "TOKEN"
}
