resource "aws_iam_role" "iam_lf_dte" {
  name               = "iam_lf_dte"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "attach_lber_lf_dte" {
  role       = aws_iam_role.iam_lf_dte.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

data "aws_iam_policy_document" "policy_lf_dte" {
  statement {
    effect    = "Allow"
    actions   = [
      "dynamodb:GetShardIterator",
      "dynamodb:DescribeStream",
      "dynamodb:ListStreams",
      "dynamodb:GetRecords"
    ]
    resources = [
      aws_dynamodb_table.integrate_event_dynamodb.stream_arn
    ]
  }

  statement {
    effect    = "Allow"
    actions   = [
      "events:PutEvents"
    ]
    resources = [
      "*"
    ]
  }
}

resource "aws_iam_policy" "policy_lf_dte" {
  name   = "policy_lf_dte"
  policy = data.aws_iam_policy_document.policy_lf_dte.json
}

resource "aws_iam_role_policy_attachment" "attach_policy_lf_dte" {
  role       = aws_iam_role.iam_lf_dte.name
  policy_arn = aws_iam_policy.policy_lf_dte.arn
}

resource "aws_cloudwatch_log_group" "loggroup_lf_dte" {
  name              = "/aws/lambda/${aws_lambda_function.dynamodb_to_eventbridge.function_name}"
  retention_in_days = 30
}

data "archive_file" "lf_dte_zip" {
  type        = "zip"
  source_dir  = "./lambda/dynamodb_to_eventbridge"
  excludes    = [
    "node_modules"
  ]
  output_path = "./lambda/lf_dte.zip"
}

resource "aws_lambda_function" "dynamodb_to_eventbridge" {
  filename         = data.archive_file.lf_dte_zip.output_path
  source_code_hash = data.archive_file.lf_dte_zip.output_base64sha256
  function_name    = "DynamoDBtoEventBridge"
  runtime          = "nodejs18.x"
  role             = aws_iam_role.iam_lf_dte.arn
  handler          = "index.handler"

  environment {
    variables = {
#      REGION         = "ap-northeast-2"
      EVENT_BUS_NAME = aws_cloudwatch_event_bus.integrate_event_bus.arn
    }
  }
}

resource "aws_lambda_event_source_mapping" "dynamodb_to_lf_dte" {
  event_source_arn  = aws_dynamodb_table.integrate_event_dynamodb.stream_arn
  function_name     = aws_lambda_function.dynamodb_to_eventbridge.arn
  starting_position = "LATEST"
}
