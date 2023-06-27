resource "aws_iam_role" "iam_lf_std" {
  name               = "iam_lf_std"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "attach_lber_lf_std" {
  role       = aws_iam_role.iam_lf_std.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

data "aws_iam_policy_document" "policy_lf_std" {
  statement {
    effect    = "Allow"
    actions   = [
      "sqs:ReceiveMessage",
      "sqs:DeleteMessage",
      "sqs:GetQueueAttributes"
    ]
    resources = [
      aws_sqs_queue.integrate_event_queue.arn
    ]
  }

  statement {
    effect    = "Allow"
    actions   = [
      "dynamodb:PutItem",
      "dynamodb:PartiQLSelect"
    ]
    resources = [
      aws_dynamodb_table.integrate_event_dynamodb.arn
    ]
  }
}

resource "aws_iam_policy" "policy_lf_std" {
  name   = "policy_lf_std"
  policy = data.aws_iam_policy_document.policy_lf_std.json
}

resource "aws_iam_role_policy_attachment" "attach_policy_lf_std" {
  role       = aws_iam_role.iam_lf_std.name
  policy_arn = aws_iam_policy.policy_lf_std.arn
}

resource "aws_cloudwatch_log_group" "loggroup_lf_std" {
  name              = "/aws/lambda/${aws_lambda_function.sqs_to_dynamodb.function_name}"
  retention_in_days = 30
}

data "archive_file" "lf_std_zip" {
  type        = "zip"
  source_dir  = "./lambda/sqs_to_dynamodb"
  excludes    = [
    "node_modules"
  ]
  output_path = "./lambda/lf_std.zip"
}

resource "aws_lambda_function" "sqs_to_dynamodb" {
  filename         = data.archive_file.lf_std_zip.output_path
  source_code_hash = data.archive_file.lf_std_zip.output_base64sha256
  function_name    = "SQStoDynamoDB"
  runtime          = "nodejs18.x"
  role             = aws_iam_role.iam_lf_std.arn
  handler          = "index.handler"

  environment {
    variables = {
#      REGION     = "ap-northeast-2"
      TABLE_NAME = aws_dynamodb_table.integrate_event_dynamodb.name
    }
  }
}

resource "aws_lambda_event_source_mapping" "sqs_to_lf_std" {
  event_source_arn = aws_sqs_queue.integrate_event_queue.arn
  function_name    = aws_lambda_function.sqs_to_dynamodb.arn
}
