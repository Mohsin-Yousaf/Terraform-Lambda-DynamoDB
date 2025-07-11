# AWS Lambda Functions
resource "aws_lambda_function" "lambda_functions" {
  for_each = toset(var.lambda_function_names)

  function_name  = "${var.aws_resource_prefix}${each.value}"
  runtime        = "nodejs22.x"
  architectures  = ["x86_64"]
  handler        = "index.handler"
  role           = "arn:aws:iam::084375577555:role/Focus-Space-Lambda-Functions-role"

  filename         = "./code.zip"
  source_code_hash = filebase64sha256("./code.zip")
}
