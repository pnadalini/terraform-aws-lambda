locals {
  db_name = "${var.env}-user"
  db_hash = "UserId"
  db_tags = {
    "Name" = "${var.env}:db"
  }
}

resource "aws_dynamodb_table" "table" {
  name           = local.db_name
  billing_mode   = "PROVISIONED"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = local.db_hash

  attribute {
    name = local.db_hash
    type = "S"
  }

  tags = local.db_tags
}
