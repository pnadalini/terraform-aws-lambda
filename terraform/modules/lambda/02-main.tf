locals {
  get_s3_key = "v1.0.0/get.zip"
  post_s3_key = "v1.0.0/post.zip"
  nodeRuntime = "nodejs12.x"
}

# Lambda Functions

resource "aws_lambda_function" "get" {
   function_name = "${var.env}-get-fc"

   s3_bucket = var.s3_bucket
   s3_key    = local.get_s3_key

   # "main" is the filename within the zip file and "handler" is the name of the 
   #  property under which the handler function was exported in that file.
   handler = "main.handler"
   runtime = local.nodeRuntime

   role = aws_iam_role.lambda_exec.arn

   environment {
    variables = {
      TABLE_NAME = var.table_name
    }
  }
}

resource "aws_lambda_function" "post" {
   function_name = "${var.env}-post-fc"

   s3_bucket = var.s3_bucket
   s3_key    = local.post_s3_key
   
   handler = "main.handler"
   runtime = local.nodeRuntime

   role = aws_iam_role.lambda_exec.arn

   environment {
    variables = {
      TABLE_NAME = var.table_name
    }
  }
}

# IAM role which dictates what other AWS services the Lambda function may access.
resource "aws_iam_role" "lambda_exec" {
   name = "serverless_example_lambda"

   assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

# DynamoDB policy to allow functions execution
resource "aws_iam_role_policy" "dynamodb_lambda_policy"{
  name = "dynamodb_lambda_policy"
  role = aws_iam_role.lambda_exec.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
          "dynamodb:BatchGet*",
          "dynamodb:DescribeStream",
          "dynamodb:DescribeTable",
          "dynamodb:Get*",
          "dynamodb:Query",
          "dynamodb:Scan",
          "dynamodb:BatchWrite*",
          "dynamodb:CreateTable",
          "dynamodb:Delete*",
          "dynamodb:Update*",
          "dynamodb:PutItem"
      ],
      "Resource": "${var.table_arn}"
    }
  ]
}
EOF
}
