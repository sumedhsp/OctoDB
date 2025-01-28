resource "aws_api_gateway_rest_api" "tfer--2dr3wn94t1_multitenantdb-test" {
  api_key_source               = "HEADER"
  description                  = "API for querying user, database, and table details."
  disable_execute_api_endpoint = "false"

  endpoint_configuration {
    types = ["REGIONAL"]
  }

  name = "multitenantdb-test"
}
