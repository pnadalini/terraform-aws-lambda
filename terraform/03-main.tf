module "vpc" {
  source = "./modules/vpc"
  env    = var.env
}

module "dynamo_db" {
  source = "./modules/dynamo-db"
  environment = var.env
}

module "lambda" {
  source = "./modules/lambda"
  environment = var.env
  table_name = module.dynamo.table_name
  table_arn = module.dynamo.table_arn
  s3_bucket = var.s3_bucket
}

module "api_gateway" {
  source = "./modules/api-gateway"
  environment = var.env
  get_function_arn = module.lambda.get_function_arn
  get_invoke_arn = module.lambda.get_invoke_arn
  post_function_arn = module.lambda.post_function_arn
  post_invoke_arn = module.lambda.post_invoke_arn
}
