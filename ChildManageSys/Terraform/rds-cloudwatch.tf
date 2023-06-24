resource "aws_cloudwatch_log_group" "rds-cloudwatch" {
  name = "rds-cloudwatch"
}

resource "aws_cloudwatch_log_stream" "rds-cloudwatch-log" {
  name           = "rds-cloudwatch-log"
  log_group_name = aws_cloudwatch_log_group.rds-cloudwatch.name
}
