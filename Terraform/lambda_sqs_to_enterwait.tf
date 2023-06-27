resource "aws_iam_role" "iam_lf_ste" {
  name               = "iam_lf_ste"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "attach_lber_lf_ste" {
  role       = aws_iam_role.iam_lf_ste.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

data "aws_iam_policy_document" "policy_lf_ste" {
  statement {
    effect    = "Allow"
    actions   = [
      "sqs:ReceiveMessage",
      "sqs:DeleteMessage",
      "sqs:GetQueueAttributes"
    ]
    resources = [
      aws_sqs_queue.event_to_enterwait_queue.arn
    ]
  }
}

resource "aws_iam_policy" "policy_lf_ste" {
  name   = "policy_lf_ste"
  policy = data.aws_iam_policy_document.policy_lf_ste.json
}

resource "aws_iam_role_policy_attachment" "attach_policy_lf_ste" {
  role       = aws_iam_role.iam_lf_ste.name
  policy_arn = aws_iam_policy.policy_lf_ste.arn
}

resource "aws_cloudwatch_log_group" "loggroup_lf_ste" {
  name              = "/aws/lambda/${aws_lambda_function.sqs_to_enterwait.function_name}"
  retention_in_days = 30
}

data "archive_file" "lf_ste_zip" {
  type        = "zip"
  source_dir  = "../ReqManageSys/sqs_to_enterwait"
  output_path = "./lf_ste.zip"
}

resource "aws_lambda_function" "sqs_to_enterwait" {
  filename         = data.archive_file.lf_ste_zip.output_path
  source_code_hash = data.archive_file.lf_ste_zip.output_base64sha256
  function_name    = "SQStoEnterwait"
  runtime          = "nodejs18.x"
  role             = aws_iam_role.iam_lf_ste.arn
  handler          = "index.handler"

  environment {
    variables = {
      ACCEPT_URL = "https://was.loveliverpool.click/request/accept"
      REJECT_URL = "https://was.loveliverpool.click/request/reject"
    }
  }
}

resource "aws_lambda_event_source_mapping" "sqs_to_lf_ste" {
  event_source_arn = aws_sqs_queue.event_to_enterwait_queue.arn
  function_name    = aws_lambda_function.sqs_to_enterwait.arn
}
