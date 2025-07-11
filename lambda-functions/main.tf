# IAM Role for Lambda Functions
resource "aws_iam_role" "lambda_role" {
  name = "${var.aws_resource_prefix}Lambda-Functions-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

# Lambda Function Deploy Policy 
resource "aws_iam_policy" "deploy_lambda_policy" {
  name        = "${var.aws_resource_prefix}Deploy-Lambda-Functions"
  description = "Policy to update Lambda functions"
  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "lambda:UpdateFunctionCode"
      ],
      "Resource": "arn:aws:lambda:ap-southeast-1:084375577555:function:Focus-Space-Staging_*"
    }
  ]
}
EOF
}

# Lambda Function DynamoDB Policy 
resource "aws_iam_policy" "dynamodb_access_policy" {
  name        = "${var.aws_resource_prefix}DynamoDB-Access-To-Lambda-Functions"
  description = "Policy for Lambda functions to access DynamoDB"
  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "FocusSpaceDynamoDB",
      "Effect": "Allow",
      "Action": [
        "dynamodb:PutItem",
        "dynamodb:DeleteItem",
        "dynamodb:GetItem",
        "dynamodb:Scan",
        "dynamodb:UpdateItem"
      ],
      "Resource": "arn:aws:dynamodb:ap-southeast-1:084375577555:table/focus-space*"
    }
  ]
}
EOF
}

# Attach IAM Policy to Role
resource "aws_iam_role_policy_attachment" "attach_deploy_lambda_policy" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.deploy_lambda_policy.arn
}

# Attach IAM Policy to Role
resource "aws_iam_role_policy_attachment" "attach_dynamodb_access_policy" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.dynamodb_access_policy.arn
}

# AWS Lambda Functions
resource "aws_lambda_function" "lambda_functions" {
  for_each = toset(var.lambda_function_names)

  function_name  = "${var.aws_resource_prefix}${each.value}"
  runtime        = "nodejs22.x"
  architectures  = ["x86_64"]
  handler        = "index.handler"
  role           = aws_iam_role.lambda_role.arn

  filename         = "./code.zip"
  source_code_hash = filebase64sha256("./code.zip")
}
