resource "aws_lambda_function" "my_lambda" {
  function_name = "my-lambda"
  runtime       = "python3.12"
  handler       = "lambda_function.lambda_handler"

  filename         = "../function.zip"
  source_code_hash = filebase64sha256("../function.zip")

  role = aws_iam_role.lambda_execution_role.arn
}


