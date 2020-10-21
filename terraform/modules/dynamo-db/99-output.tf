output "table_name" {
  description = "The name of the table"
  value       = aws_dynamodb_table.table.id
}

output "table_arn" {
  description = "The arn of the table"
  value       = aws_dynamodb_table.table.arn
}
