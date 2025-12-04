output "table_name" {
  value = aws_dynamodb_table.data.name
}

output "table_arn" {
  value = aws_dynamodb_table.data.arn
}