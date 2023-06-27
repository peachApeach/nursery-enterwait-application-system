resource "aws_iam_role" "iam_lf_stn" {
  name               = "iam_lf_stn"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "attach_lber_lf_stn" {
  role       = aws_iam_role.iam_lf_stn.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

data "aws_iam_policy_document" "policy_lf_stn" {
  statement {
    effect    = "Allow"
    actions   = [
      "sqs:ReceiveMessage",
      "sqs:DeleteMessage",
      "sqs:GetQueueAttributes"
    ]
    resources = [
      aws_sqs_queue.event_to_nursery_queue.arn
    ]
  }
}

resource "aws_iam_policy" "policy_lf_stn" {
  name   = "policy_lf_stn"
  policy = data.aws_iam_policy_document.policy_lf_stn.json
}

resource "aws_iam_role_policy_attachment" "attach_policy_lf_stn" {
  role       = aws_iam_role.iam_lf_stn.name
  policy_arn = aws_iam_policy.policy_lf_stn.arn
}

resource "aws_cloudwatch_log_group" "loggroup_lf_stn" {
  name              = "/aws/lambda/${aws_lambda_function.sqs_to_nursery.function_name}"
  retention_in_days = 30
}

data "archive_file" "lf_stn_zip" {
  type        = "zip"
  source_dir  = "./lambda/sqs_to_nursery"
  output_path = "./lambda/lf_stn.zip"
}

resource "aws_lambda_function" "sqs_to_nursery" {
  filename         = data.archive_file.lf_stn_zip.output_path
  source_code_hash = data.archive_file.lf_stn_zip.output_base64sha256
  function_name    = "SQStoNursery"
  runtime          = "nodejs18.x"
  role             = aws_iam_role.iam_lf_stn.arn
  handler          = "index.handler"

  environment {
    variables = {
      REQUEST_URL = "http://ec2-13-209-17-137.ap-northeast-2.compute.amazonaws.com:4000/enterwait/request"
      CANCEL_URL = "http://ec2-13-209-17-137.ap-northeast-2.compute.amazonaws.com:4000/enterwait/cancel"
    }
  }
}

resource "aws_lambda_event_source_mapping" "sqs_to_lf_stn" {
  event_source_arn = aws_sqs_queue.event_to_nursery_queue.arn
  function_name    = aws_lambda_function.sqs_to_nursery.arn
}
