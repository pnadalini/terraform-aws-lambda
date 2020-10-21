output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "api_url" {
  description = "Base url of API Gateway"
  value       = module.apiGateway.api_url
}
