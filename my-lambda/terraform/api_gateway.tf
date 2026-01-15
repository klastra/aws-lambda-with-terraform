// Creates the API itself
resource "aws_api_gateway_rest_api" "my_api" {
  name = "my-lambda-api"
}

// Defines a /count path
resource "aws_api_gateway_resource" "count" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  parent_id   = aws_api_gateway_rest_api.my_api.root_resource_id
  path_part   = "count"
}

// Allows POST on /count path
resource "aws_api_gateway_method" "count_post" {
  rest_api_id   = aws_api_gateway_rest_api.my_api.id
  resource_id   = aws_api_gateway_resource.count.id
  http_method   = "POST"
  authorization = "NONE"
}

// API Gateway → Lambda integration
resource "aws_api_gateway_integration" "count_lambda" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.count.id
  http_method = aws_api_gateway_method.count_post.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.my_lambda.invoke_arn
}

// Lets API Gateway call Lambda (Lambda is locked down by default)
resource "aws_lambda_permission" "api_gateway" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.my_lambda.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.my_api.execution_arn}/*/*"
}

// Deploys the API
resource "aws_api_gateway_deployment" "my_api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id

  depends_on = [
    aws_api_gateway_integration.count_lambda
  ]
}

resource "aws_api_gateway_stage" "dev" {
  deployment_id = aws_api_gateway_deployment.my_api_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.my_api.id
  stage_name    = "dev"
}
