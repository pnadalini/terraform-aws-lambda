# API Gateway

resource "aws_api_gateway_rest_api" "api" {
  name        = "${var.env}-api"
  description = "Terraform Serverless Application"
}

resource "aws_api_gateway_resource" "proxy" {
   rest_api_id = aws_api_gateway_rest_api.api.id
   parent_id   = aws_api_gateway_rest_api.api.root_resource_id
   path_part   = "{proxy+}"
}

# Lamda Functions

# GET
resource "aws_api_gateway_method" "get" {
   rest_api_id   = aws_api_gateway_rest_api.api.id
   resource_id   = aws_api_gateway_resource.proxy.id
   http_method   = "GET"
   authorization = "NONE"
}

resource "aws_api_gateway_integration" "get" {
   rest_api_id = aws_api_gateway_rest_api.api.id
   resource_id = aws_api_gateway_method.get.resource_id
   http_method = aws_api_gateway_method.get.http_method

   integration_http_method = "POST"
   type                    = "AWS_PROXY"
   uri                     = var.get_invoke_arn
}

resource "aws_lambda_permission" "api_gw_get" {
   statement_id  = "AllowAPIGatewayInvoke"
   action        = "lambda:InvokeFunction"
   function_name = var.get_function_arn
   principal     = "apigateway.amazonaws.com"

   source_arn = "${aws_api_gateway_rest_api.api.execution_arn}/*/*"
}

# POST
resource "aws_api_gateway_method" "post" {
   rest_api_id   = aws_api_gateway_rest_api.api.id
   resource_id   = aws_api_gateway_resource.proxy.id
   http_method   = "POST"
   authorization = "NONE"
}

resource "aws_api_gateway_integration" "post" {
   rest_api_id = aws_api_gateway_rest_api.api.id
   resource_id = aws_api_gateway_method.post.resource_id
   http_method = aws_api_gateway_method.post.http_method

   integration_http_method = "POST"
   type                    = "AWS_PROXY"
   uri                     = var.post_invoke_arn
}

resource "aws_lambda_permission" "api_gw_post" {
   statement_id  = "AllowAPIGatewayInvoke"
   action        = "lambda:InvokeFunction"
   function_name = var.post_function_arn
   principal     = "apigateway.amazonaws.com"

   source_arn = "${aws_api_gateway_rest_api.api.execution_arn}/*/*"
}

# Deploy

resource "aws_api_gateway_deployment" "deploy" {
   depends_on = [
     aws_api_gateway_integration.get,
     aws_api_gateway_method.get,
     aws_api_gateway_integration.post,
     aws_api_gateway_method.post
   ]

   rest_api_id = aws_api_gateway_rest_api.api.id
   stage_name  = var.env
}
