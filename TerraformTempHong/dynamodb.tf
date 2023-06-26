resource "aws_dynamodb_table" "integrate_event_dynamodb" {
  name           = "IntegrateEventDynamoDB"
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "request_id"
  range_key      = "create_date"
  stream_enabled = true
  stream_view_type = "NEW_AND_OLD_IMAGES"

  attribute {
    name = "request_id"
    type = "S"
  }

  attribute {
    name = "create_date"
    type = "S"
  }
}
