output "dynamodb_table_names" {
  description = "Names of the DynamoDB tables created."
  value       = [for table in aws_dynamodb_table.tables : table.name]
}
