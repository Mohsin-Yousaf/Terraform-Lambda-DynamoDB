resource "aws_dynamodb_table" "tables" {
  for_each = toset(var.dynamodb_table_names)

  name         = "${var.aws_resource_prefix}${each.value}"
  billing_mode = "PAY_PER_REQUEST" # Change to "PROVISIONED" if needed
  # Set hash and sort keys conditionally
  hash_key  = each.value == "users-work-time" ? "user_id" : "id"
  range_key = each.value == "users-work-time" ? "date" : null


  # Conditional for partition and sort key setup
  dynamic "attribute" {
    for_each = each.value == "users-work-time" ? [
      { name = "user_id", type = "S" },
      { name = "date", type = "S" }
    ] : [
      { name = "id", type = "S" }
    ]

    content {
      name = attribute.value.name
      type = attribute.value.type
    }
  }


  tags = {
    Environment = "staging"
    ManagedBy   = "Terraform"
  }
}
