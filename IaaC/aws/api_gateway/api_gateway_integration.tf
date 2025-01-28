resource "aws_api_gateway_integration" "tfer--2dr3wn94t1-002F-6sv64a-002F-OPTIONS" {
  cache_namespace      = "6sv64a"
  connection_type      = "INTERNET"
  http_method          = "OPTIONS"
  passthrough_behavior = "WHEN_NO_MATCH"

  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }

  resource_id          = "6sv64a"
  rest_api_id          = "2dr3wn94t1"
  timeout_milliseconds = "29000"
  type                 = "MOCK"
}

resource "aws_api_gateway_integration" "tfer--2dr3wn94t1-002F-6sv64a-002F-POST" {
  cache_namespace         = "6sv64a"
  connection_type         = "INTERNET"
  content_handling        = "CONVERT_TO_TEXT"
  http_method             = "POST"
  integration_http_method = "POST"
  passthrough_behavior    = "WHEN_NO_MATCH"
  resource_id             = "6sv64a"
  rest_api_id             = "2dr3wn94t1"
  timeout_milliseconds    = "29000"
  type                    = "AWS"
  uri                     = "arn:aws:apigateway:us-east-2:lambda:path/2015-03-31/functions/arn:aws:lambda:us-east-2:571600864139:function:testFunction/invocations"
}

resource "aws_api_gateway_integration" "tfer--2dr3wn94t1-002F-f3b1vg-002F-OPTIONS" {
  cache_namespace      = "f3b1vg"
  connection_type      = "INTERNET"
  http_method          = "OPTIONS"
  passthrough_behavior = "WHEN_NO_MATCH"

  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }

  resource_id          = "f3b1vg"
  rest_api_id          = "2dr3wn94t1"
  timeout_milliseconds = "29000"
  type                 = "MOCK"
}

resource "aws_api_gateway_integration" "tfer--2dr3wn94t1-002F-f3b1vg-002F-POST" {
  cache_namespace         = "f3b1vg"
  connection_type         = "INTERNET"
  content_handling        = "CONVERT_TO_TEXT"
  http_method             = "POST"
  integration_http_method = "POST"
  passthrough_behavior    = "WHEN_NO_MATCH"
  resource_id             = "f3b1vg"
  rest_api_id             = "2dr3wn94t1"
  timeout_milliseconds    = "29000"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:us-east-2:lambda:path/2015-03-31/functions/arn:aws:lambda:us-east-2:571600864139:function:handleQuery/invocations"
}

resource "aws_api_gateway_integration" "tfer--2dr3wn94t1-002F-fb2z28-002F-OPTIONS" {
  cache_namespace      = "fb2z28"
  connection_type      = "INTERNET"
  http_method          = "OPTIONS"
  passthrough_behavior = "WHEN_NO_MATCH"

  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }

  resource_id          = "fb2z28"
  rest_api_id          = "2dr3wn94t1"
  timeout_milliseconds = "29000"
  type                 = "MOCK"
}

resource "aws_api_gateway_integration" "tfer--2dr3wn94t1-002F-fb2z28-002F-POST" {
  cache_namespace         = "fb2z28"
  connection_type         = "INTERNET"
  content_handling        = "CONVERT_TO_TEXT"
  http_method             = "POST"
  integration_http_method = "POST"
  passthrough_behavior    = "WHEN_NO_MATCH"
  resource_id             = "fb2z28"
  rest_api_id             = "2dr3wn94t1"
  timeout_milliseconds    = "29000"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:us-east-2:lambda:path/2015-03-31/functions/arn:aws:lambda:us-east-2:571600864139:function:dashboard/invocations"
}

resource "aws_api_gateway_integration" "tfer--2dr3wn94t1-002F-iaf58g-002F-OPTIONS" {
  cache_namespace      = "iaf58g"
  connection_type      = "INTERNET"
  http_method          = "OPTIONS"
  passthrough_behavior = "WHEN_NO_MATCH"

  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }

  resource_id          = "iaf58g"
  rest_api_id          = "2dr3wn94t1"
  timeout_milliseconds = "29000"
  type                 = "MOCK"
}

resource "aws_api_gateway_integration" "tfer--2dr3wn94t1-002F-iaf58g-002F-POST" {
  cache_namespace         = "iaf58g"
  connection_type         = "INTERNET"
  content_handling        = "CONVERT_TO_TEXT"
  http_method             = "POST"
  integration_http_method = "POST"
  passthrough_behavior    = "WHEN_NO_MATCH"
  resource_id             = "iaf58g"
  rest_api_id             = "2dr3wn94t1"
  timeout_milliseconds    = "29000"
  type                    = "AWS"
  uri                     = "arn:aws:apigateway:us-east-2:lambda:path/2015-03-31/functions/arn:aws:lambda:us-east-2:571600864139:function:generateUserTokens/invocations"
}

resource "aws_api_gateway_integration" "tfer--2dr3wn94t1-002F-k7mfer-002F-OPTIONS" {
  cache_namespace      = "k7mfer"
  connection_type      = "INTERNET"
  http_method          = "OPTIONS"
  passthrough_behavior = "WHEN_NO_MATCH"

  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }

  resource_id          = "k7mfer"
  rest_api_id          = "2dr3wn94t1"
  timeout_milliseconds = "29000"
  type                 = "MOCK"
}

resource "aws_api_gateway_integration" "tfer--2dr3wn94t1-002F-k7mfer-002F-POST" {
  cache_namespace         = "k7mfer"
  connection_type         = "INTERNET"
  content_handling        = "CONVERT_TO_TEXT"
  http_method             = "POST"
  integration_http_method = "POST"
  passthrough_behavior    = "WHEN_NO_MATCH"
  resource_id             = "k7mfer"
  rest_api_id             = "2dr3wn94t1"
  timeout_milliseconds    = "29000"
  type                    = "AWS"
  uri                     = "arn:aws:apigateway:us-east-2:lambda:path/2015-03-31/functions/arn:aws:lambda:us-east-2:571600864139:function:validateUser/invocations"
}

resource "aws_api_gateway_integration" "tfer--2dr3wn94t1-002F-odri5q-002F-OPTIONS" {
  cache_namespace      = "odri5q"
  connection_type      = "INTERNET"
  http_method          = "OPTIONS"
  passthrough_behavior = "WHEN_NO_MATCH"

  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }

  resource_id          = "odri5q"
  rest_api_id          = "2dr3wn94t1"
  timeout_milliseconds = "29000"
  type                 = "MOCK"
}

resource "aws_api_gateway_integration" "tfer--2dr3wn94t1-002F-odri5q-002F-POST" {
  cache_namespace         = "odri5q"
  connection_type         = "INTERNET"
  content_handling        = "CONVERT_TO_TEXT"
  http_method             = "POST"
  integration_http_method = "POST"
  passthrough_behavior    = "WHEN_NO_MATCH"
  resource_id             = "odri5q"
  rest_api_id             = "2dr3wn94t1"
  timeout_milliseconds    = "29000"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:us-east-2:lambda:path/2015-03-31/functions/arn:aws:lambda:us-east-2:571600864139:function:M0/invocations"
}
