resource "aws_api_gateway_model" "tfer--c4oqz0" {
  content_type = "application/json"
  name         = "MODEL9d1f09"
  rest_api_id  = "2dr3wn94t1"
  schema       = "{\n  \"type\" : \"object\",\n  \"properties\" : {\n    \"action\" : {\n      \"type\" : \"string\",\n      \"description\" : \"Action to perform (e.g., get_user_info, get_user_databases, etc.)\"\n    },\n    \"UserId\" : {\n      \"type\" : \"string\",\n      \"description\" : \"ID of the user (required for user-related actions)\"\n    },\n    \"Db_id\" : {\n      \"type\" : \"string\",\n      \"description\" : \"ID of the database (required for database-related actions)\"\n    },\n    \"TableId\" : {\n      \"type\" : \"string\",\n      \"description\" : \"ID of the table (required for table-related actions)\"\n    }\n  }\n}"
}

resource "aws_api_gateway_model" "tfer--fojcvc" {
  content_type = "application/json"
  name         = "MODEL604713"
  rest_api_id  = "2dr3wn94t1"
  schema       = "{\n  \"type\" : \"object\",\n  \"properties\" : {\n    \"statusCode\" : {\n      \"type\" : \"integer\",\n      \"format\" : \"int32\"\n    },\n    \"body\" : {\n      \"type\" : \"object\",\n      \"description\" : \"Operation result\",\n      \"properties\" : { }\n    }\n  }\n}"
}

resource "aws_api_gateway_model" "tfer--fvqdc0" {
  content_type = "application/json"
  name         = "MODEL5a0976"
  rest_api_id  = "2dr3wn94t1"
  schema       = "{\n  \"type\" : \"object\",\n  \"required\" : [ \"fileName\", \"query\" ],\n  \"properties\" : {\n    \"fileName\" : {\n      \"type\" : \"string\",\n      \"description\" : \"Name of the SQLite file to query.\"\n    },\n    \"query\" : {\n      \"type\" : \"string\",\n      \"description\" : \"SQL query to execute.\"\n    }\n  }\n}"
}

resource "aws_api_gateway_model" "tfer--n9x10d" {
  content_type = "application/json"
  description  = "This is a default empty schema model"
  name         = "Empty"
  rest_api_id  = "2dr3wn94t1"
  schema       = "{\n  \"$schema\": \"http://json-schema.org/draft-04/schema#\",\n  \"title\" : \"Empty Schema\",\n  \"type\" : \"object\"\n}"
}

resource "aws_api_gateway_model" "tfer--oimt49" {
  content_type = "application/json"
  description  = "This is a default error schema model"
  name         = "Error"
  rest_api_id  = "2dr3wn94t1"
  schema       = "{\n  \"$schema\" : \"http://json-schema.org/draft-04/schema#\",\n  \"title\" : \"Error Schema\",\n  \"type\" : \"object\",\n  \"properties\" : {\n    \"message\" : { \"type\" : \"string\" }\n  }\n}"
}

resource "aws_api_gateway_model" "tfer--ylb482" {
  content_type = "application/json"
  name         = "MODEL741e81"
  rest_api_id  = "2dr3wn94t1"
  schema       = "{\n  \"type\" : \"object\",\n  \"properties\" : {\n    \"message\" : {\n      \"type\" : \"string\"\n    },\n    \"queryResults\" : {\n      \"type\" : \"array\",\n      \"items\" : {\n        \"type\" : \"object\",\n        \"properties\" : { }\n      }\n    }\n  }\n}"
}
