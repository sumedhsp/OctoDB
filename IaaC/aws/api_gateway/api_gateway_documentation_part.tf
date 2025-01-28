resource "aws_api_gateway_documentation_part" "tfer--2dr3wn94t1-002F-114yz8" {
  location {
    name = "MODEL9d1f09.TableId"
    type = "MODEL"
  }

  properties  = "{\n  \"description\" : \"ID of the table (required for table-related actions)\"\n}"
  rest_api_id = "2dr3wn94t1"
}

resource "aws_api_gateway_documentation_part" "tfer--2dr3wn94t1-002F-35z34c" {
  location {
    method      = "POST"
    path        = "/dashboard"
    status_code = "404"
    type        = "RESPONSE"
  }

  properties  = "{\n  \"description\" : \"404 response\"\n}"
  rest_api_id = "2dr3wn94t1"
}

resource "aws_api_gateway_documentation_part" "tfer--2dr3wn94t1-002F-4irl2i" {
  location {
    name = "MODEL5a0976.query"
    type = "MODEL"
  }

  properties  = "{\n  \"description\" : \"SQL query to execute.\"\n}"
  rest_api_id = "2dr3wn94t1"
}

resource "aws_api_gateway_documentation_part" "tfer--2dr3wn94t1-002F-689did" {
  location {
    type = "API"
  }

  properties  = "{\n  \"info\" : {\n    \"description\" : \"API for querying user, database, and table details.\"\n  }\n}"
  rest_api_id = "2dr3wn94t1"
}

resource "aws_api_gateway_documentation_part" "tfer--2dr3wn94t1-002F-6jvgss" {
  location {
    name = "MODEL9d1f09.action"
    type = "MODEL"
  }

  properties  = "{\n  \"description\" : \"Action to perform (e.g., get_user_info, get_user_databases, etc.)\"\n}"
  rest_api_id = "2dr3wn94t1"
}

resource "aws_api_gateway_documentation_part" "tfer--2dr3wn94t1-002F-dxfcr6" {
  location {
    method      = "POST"
    path        = "/dashboard"
    status_code = "500"
    type        = "RESPONSE"
  }

  properties  = "{\n  \"description\" : \"500 response\"\n}"
  rest_api_id = "2dr3wn94t1"
}

resource "aws_api_gateway_documentation_part" "tfer--2dr3wn94t1-002F-eyz0so" {
  location {
    method      = "POST"
    path        = "/dashboard"
    status_code = "400"
    type        = "RESPONSE"
  }

  properties  = "{\n  \"description\" : \"400 response\"\n}"
  rest_api_id = "2dr3wn94t1"
}

resource "aws_api_gateway_documentation_part" "tfer--2dr3wn94t1-002F-gr2hfe" {
  location {
    method      = "POST"
    path        = "/dashboard"
    status_code = "200"
    type        = "RESPONSE"
  }

  properties  = "{\n  \"description\" : \"200 response\"\n}"
  rest_api_id = "2dr3wn94t1"
}

resource "aws_api_gateway_documentation_part" "tfer--2dr3wn94t1-002F-gtjoxh" {
  location {
    method      = "POST"
    path        = "/query"
    status_code = "200"
    type        = "RESPONSE"
  }

  properties  = "{\n  \"description\" : \"200 response\"\n}"
  rest_api_id = "2dr3wn94t1"
}

resource "aws_api_gateway_documentation_part" "tfer--2dr3wn94t1-002F-gv0rz5" {
  location {
    method      = "POST"
    path        = "/query"
    status_code = "500"
    type        = "RESPONSE"
  }

  properties  = "{\n  \"description\" : \"500 response\"\n}"
  rest_api_id = "2dr3wn94t1"
}

resource "aws_api_gateway_documentation_part" "tfer--2dr3wn94t1-002F-hj28bc" {
  location {
    method      = "POST"
    path        = "/query"
    status_code = "400"
    type        = "RESPONSE"
  }

  properties  = "{\n  \"description\" : \"400 response\"\n}"
  rest_api_id = "2dr3wn94t1"
}

resource "aws_api_gateway_documentation_part" "tfer--2dr3wn94t1-002F-j50v8d" {
  location {
    name = "MODEL9d1f09.UserId"
    type = "MODEL"
  }

  properties  = "{\n  \"description\" : \"ID of the user (required for user-related actions)\"\n}"
  rest_api_id = "2dr3wn94t1"
}

resource "aws_api_gateway_documentation_part" "tfer--2dr3wn94t1-002F-jz8ua3" {
  location {
    name = "MODEL5a0976.fileName"
    type = "MODEL"
  }

  properties  = "{\n  \"description\" : \"Name of the SQLite file to query.\"\n}"
  rest_api_id = "2dr3wn94t1"
}

resource "aws_api_gateway_documentation_part" "tfer--2dr3wn94t1-002F-p8q9jj" {
  location {
    name = "MODEL604713.body"
    type = "MODEL"
  }

  properties  = "{\n  \"description\" : \"Operation result\"\n}"
  rest_api_id = "2dr3wn94t1"
}

resource "aws_api_gateway_documentation_part" "tfer--2dr3wn94t1-002F-rrxasi" {
  location {
    name = "MODEL9d1f09.Db_id"
    type = "MODEL"
  }

  properties  = "{\n  \"description\" : \"ID of the database (required for database-related actions)\"\n}"
  rest_api_id = "2dr3wn94t1"
}
