resource "aws_iam_role" "iam_lf_se" {
  name               = "iam_lf_se"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "attach_lber_lf_se" {
  role       = aws_iam_role.iam_lf_se.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

data "aws_iam_policy_document" "policy_lf_se" {
  statement {
    effect    = "Allow"
    actions   = [
      "ses:SendEmail"
    ]
    resources = [
      "*"
    ]
  }
}

resource "aws_iam_policy" "policy_lf_se" {
  name   = "policy_lf_se"
  policy = data.aws_iam_policy_document.policy_lf_se.json
}

resource "aws_iam_role_policy_attachment" "attach_policy_lf_se" {
  role       = aws_iam_role.iam_lf_se.name
  policy_arn = aws_iam_policy.policy_lf_se.arn
}

resource "aws_cloudwatch_log_group" "loggroup_lf_se" {
  name              = "/aws/lambda/${aws_lambda_function.send_email.function_name}"
  retention_in_days = 30
}

data "archive_file" "lf_se_zip" {
  type        = "zip"
  source_dir  = "../ReqManageSys/send_email"
  excludes    = [
    "node_modules"
  ]
  output_path = "./lf_se.zip"
}

resource "aws_lambda_function" "send_email" {
  filename         = data.archive_file.lf_se_zip.output_path
  source_code_hash = data.archive_file.lf_se_zip.output_base64sha256
  function_name    = "SendEmail"
  runtime          = "nodejs18.x"
  role             = aws_iam_role.iam_lf_se.arn
  handler          = "index.handler"
}

resource "aws_lambda_permission" "allow_request" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.send_email.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.request.arn
}

resource "aws_lambda_permission" "allow_cancel" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.send_email.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.cancel.arn
}

resource "aws_lambda_permission" "allow_accept" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.send_email.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.accept.arn
}

resource "aws_lambda_permission" "allow_reject" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.send_email.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.reject.arn
}
