resource "aws_sqs_queue" "integrate_event_queue" {
  name = "IntegrateEventQueue"
}

data "aws_iam_policy_document" "ieq_policy" {
  statement {
    sid       = "IEQ001"
    effect    = "Allow"
    actions   = ["sqs:SendMessage"]
    resources = [aws_sqs_queue.integrate_event_queue.arn]
  }
}

resource "aws_sqs_queue_policy" "ieq_policy" {
  queue_url = aws_sqs_queue.integrate_event_queue.id
  policy    = data.aws_iam_policy_document.ieq_policy.json
}

resource "aws_sqs_queue" "event_to_nursery_queue" {
  name = "EventToNurseryQueue"
}

data "aws_iam_policy_document" "etnq_policy" {
  statement {
    sid       = "ETNQ001"
    effect    = "Allow"
    actions   = [
      "sqs:SendMessage"
    ]
    resources = [
      aws_sqs_queue.event_to_nursery_queue.arn
    ]

    condition {
      test     = "ArnEquals"
      variable = "aws:SourceArn"
      values   = [
        aws_cloudwatch_event_rule.request.arn,
        aws_cloudwatch_event_rule.cancel.arn
      ]
    }

    principals {
      type        = "Service"
      identifiers = [
       "events.amazonaws.com"
      ]
    }
  }
}

resource "aws_sqs_queue_policy" "etnq_policy" {
  queue_url = aws_sqs_queue.event_to_nursery_queue.id
  policy    = data.aws_iam_policy_document.etnq_policy.json
}

resource "aws_sqs_queue" "event_to_enterwait_queue" {
  name = "EventToEnterwaitQueue"
}

data "aws_iam_policy_document" "eteq_policy" {
  statement {
    sid       = "ETEQ001"
    effect    = "Allow"
    actions   = [
      "sqs:SendMessage"
    ]
    resources = [
      aws_sqs_queue.event_to_enterwait_queue.arn
    ]

    condition {
      test     = "ArnEquals"
      variable = "aws:SourceArn"
      values   = [
        aws_cloudwatch_event_rule.accept.arn,
        aws_cloudwatch_event_rule.reject.arn
      ]
    }

    principals {
      type        = "Service"
      identifiers = [
        "events.amazonaws.com"
      ]
    }
  }
}

resource "aws_sqs_queue_policy" "eteq_policy" {
  queue_url = aws_sqs_queue.event_to_enterwait_queue.id
  policy    = data.aws_iam_policy_document.eteq_policy.json
}
