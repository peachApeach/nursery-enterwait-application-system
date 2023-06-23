resource "aws_cloudwatch_event_bus" "integrate_event_bus" {
  name = "IntegrateEventBus"
}

resource "aws_cloudwatch_event_rule" "request" {
  name           = "Request"
  event_bus_name = aws_cloudwatch_event_bus.integrate_event_bus.arn

  event_pattern = jsonencode({
    source      = [
      "DynamoDB"
    ]
    detail-type = [
      "Request"
    ]
  })
}

resource "aws_cloudwatch_event_target" "request_target" {
  arn            = aws_lambda_function.send_email.arn
  rule           = aws_cloudwatch_event_rule.request.name
  event_bus_name = aws_cloudwatch_event_bus.integrate_event_bus.arn
}

resource "aws_cloudwatch_event_target" "request_queue_target" {
  arn            = aws_sqs_queue.event_to_nursery_queue.arn
  rule           = aws_cloudwatch_event_rule.request.name
  event_bus_name = aws_cloudwatch_event_bus.integrate_event_bus.arn
}

resource "aws_cloudwatch_event_rule" "cancel" {
  name           = "Cancel"
  event_bus_name = aws_cloudwatch_event_bus.integrate_event_bus.arn

  event_pattern = jsonencode({
    source      = [
      "DynamoDB"
    ]
    detail-type = [
      "Cancel"
    ]
  })
}

resource "aws_cloudwatch_event_target" "cancel_target" {
  arn            = aws_lambda_function.send_email.arn
  rule           = aws_cloudwatch_event_rule.cancel.name
  event_bus_name = aws_cloudwatch_event_bus.integrate_event_bus.arn
}

resource "aws_cloudwatch_event_target" "cancel_queue_target" {
  arn            = aws_sqs_queue.event_to_nursery_queue.arn
  rule           = aws_cloudwatch_event_rule.cancel.name
  event_bus_name = aws_cloudwatch_event_bus.integrate_event_bus.arn
}

resource "aws_cloudwatch_event_rule" "accept" {
  name           = "Accept"
  event_bus_name = aws_cloudwatch_event_bus.integrate_event_bus.arn

  event_pattern = jsonencode({
    source      = [
      "DynamoDB"
    ]
    detail-type = [
      "Accept"
    ]
  })
}

resource "aws_cloudwatch_event_target" "accept_target" {
  arn            = aws_lambda_function.send_email.arn
  rule           = aws_cloudwatch_event_rule.accept.name
  event_bus_name = aws_cloudwatch_event_bus.integrate_event_bus.arn
}

resource "aws_cloudwatch_event_target" "accept_queue_target" {
  arn            = aws_sqs_queue.event_to_enterwait_queue.arn
  rule           = aws_cloudwatch_event_rule.accept.name
  event_bus_name = aws_cloudwatch_event_bus.integrate_event_bus.arn
}

resource "aws_cloudwatch_event_rule" "reject" {
  name           = "Reject"
  event_bus_name = aws_cloudwatch_event_bus.integrate_event_bus.arn

  event_pattern = jsonencode({
    source      = [
      "DynamoDB"
    ]
    detail-type = [
      "Reject"
    ]
  })
}

resource "aws_cloudwatch_event_target" "reject_target" {
  arn            = aws_lambda_function.send_email.arn
  rule           = aws_cloudwatch_event_rule.reject.name
  event_bus_name = aws_cloudwatch_event_bus.integrate_event_bus.arn
}

resource "aws_cloudwatch_event_target" "reject_queue_target" {
  arn            = aws_sqs_queue.event_to_enterwait_queue.arn
  rule           = aws_cloudwatch_event_rule.reject.name
  event_bus_name = aws_cloudwatch_event_bus.integrate_event_bus.arn
}
