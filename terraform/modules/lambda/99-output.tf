output "get_function_arn" {
  description = "ARN name of the get function"
  value       = aws_lambda_function.get.arn
}

output "get_invoke_arn" {
  description = "The invoke arn of the get function"
  value       = aws_lambda_function.get.invoke_arn
}

output "post_function_arn" {
  description = "ARN name of the post function"
  value       = aws_lambda_function.post.arn
}

output "post_invoke_arn" {
  description = "The invoke arn of the post function"
  value       = aws_lambda_function.post.invoke_arn
}
