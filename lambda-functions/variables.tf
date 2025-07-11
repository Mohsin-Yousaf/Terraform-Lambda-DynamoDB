variable "aws_access_key" {}
variable "aws_secret_key" {}
#variable "aws_account_id" {}

variable "aws_region" {}

variable "aws_resource_prefix" {
  description = "Prefix for all AWS resources."
  type        = string
}

variable "lambda_function_names" {
  description = "List of Lambda function names"
  type        = list(string)
}
