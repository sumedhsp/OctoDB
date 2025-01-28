resource "aws_api_gateway_stage" "tfer--2dr3wn94t1-002F-dev" {
  cache_cluster_enabled = "false"
  deployment_id         = "zyt3k0"
  rest_api_id           = "2dr3wn94t1"
  stage_name            = "dev"
  xray_tracing_enabled  = "false"
}

resource "aws_api_gateway_stage" "tfer--2dr3wn94t1-002F-test_v1" {
  cache_cluster_enabled = "false"
  deployment_id         = "g5o1g6"
  rest_api_id           = "2dr3wn94t1"
  stage_name            = "test_v1"
  xray_tracing_enabled  = "false"
}

resource "aws_api_gateway_stage" "tfer--2dr3wn94t1-002F-utkarsh_stage" {
  cache_cluster_enabled = "false"
  deployment_id         = "kr5rz0"
  rest_api_id           = "2dr3wn94t1"
  stage_name            = "utkarsh_stage"
  xray_tracing_enabled  = "false"
}
