resource "aws_api_gateway_method" "tfer--2dr3wn94t1-002F-6sv64a-002F-OPTIONS" {
  api_key_required = "false"
  authorization    = "NONE"
  http_method      = "OPTIONS"
  resource_id      = "6sv64a"
  rest_api_id      = "2dr3wn94t1"
}

resource "aws_api_gateway_method" "tfer--2dr3wn94t1-002F-6sv64a-002F-POST" {
  api_key_required = "false"
  authorization    = "NONE"
  http_method      = "POST"
  resource_id      = "6sv64a"
  rest_api_id      = "2dr3wn94t1"
}

resource "aws_api_gateway_method" "tfer--2dr3wn94t1-002F-f3b1vg-002F-OPTIONS" {
  api_key_required = "false"
  authorization    = "NONE"
  http_method      = "OPTIONS"
  resource_id      = "f3b1vg"
  rest_api_id      = "2dr3wn94t1"
}

resource "aws_api_gateway_method" "tfer--2dr3wn94t1-002F-f3b1vg-002F-POST" {
  api_key_required = "false"
  authorization    = "CUSTOM"
  authorizer_id    = "0w9k5i"
  http_method      = "POST"

  request_models = {
    "application/json" = "MODEL5a0976"
  }

  resource_id = "f3b1vg"
  rest_api_id = "2dr3wn94t1"
}

resource "aws_api_gateway_method" "tfer--2dr3wn94t1-002F-fb2z28-002F-OPTIONS" {
  api_key_required = "false"
  authorization    = "NONE"
  http_method      = "OPTIONS"
  resource_id      = "fb2z28"
  rest_api_id      = "2dr3wn94t1"
}

resource "aws_api_gateway_method" "tfer--2dr3wn94t1-002F-fb2z28-002F-POST" {
  api_key_required = "false"
  authorization    = "CUSTOM"
  authorizer_id    = "0w9k5i"
  http_method      = "POST"

  request_models = {
    "application/json" = "MODEL9d1f09"
  }

  resource_id = "fb2z28"
  rest_api_id = "2dr3wn94t1"
}

resource "aws_api_gateway_method" "tfer--2dr3wn94t1-002F-iaf58g-002F-OPTIONS" {
  api_key_required = "false"
  authorization    = "NONE"
  http_method      = "OPTIONS"
  resource_id      = "iaf58g"
  rest_api_id      = "2dr3wn94t1"
}

resource "aws_api_gateway_method" "tfer--2dr3wn94t1-002F-iaf58g-002F-POST" {
  api_key_required = "false"
  authorization    = "NONE"
  http_method      = "POST"
  resource_id      = "iaf58g"
  rest_api_id      = "2dr3wn94t1"
}

resource "aws_api_gateway_method" "tfer--2dr3wn94t1-002F-k7mfer-002F-OPTIONS" {
  api_key_required = "false"
  authorization    = "NONE"
  http_method      = "OPTIONS"
  resource_id      = "k7mfer"
  rest_api_id      = "2dr3wn94t1"
}

resource "aws_api_gateway_method" "tfer--2dr3wn94t1-002F-k7mfer-002F-POST" {
  api_key_required = "false"
  authorization    = "NONE"
  http_method      = "POST"
  resource_id      = "k7mfer"
  rest_api_id      = "2dr3wn94t1"
}

resource "aws_api_gateway_method" "tfer--2dr3wn94t1-002F-odri5q-002F-OPTIONS" {
  api_key_required = "false"
  authorization    = "NONE"
  http_method      = "OPTIONS"
  resource_id      = "odri5q"
  rest_api_id      = "2dr3wn94t1"
}

resource "aws_api_gateway_method" "tfer--2dr3wn94t1-002F-odri5q-002F-POST" {
  api_key_required = "false"
  authorization    = "CUSTOM"
  authorizer_id    = "0w9k5i"
  http_method      = "POST"
  resource_id      = "odri5q"
  rest_api_id      = "2dr3wn94t1"
}
