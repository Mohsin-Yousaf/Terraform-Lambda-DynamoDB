output "lambda_function_arns" {
  description = "ARNs of all Lambda functions"
  value       = values(aws_lambda_function.lambda_functions)[*].arn
}
