#archive the source code of the lambda

data "archive_file" "nuvalence_lambda" {
  type = "zip"

  source_dir  = "${path.module}/source"
  output_path = "${path.module}/nuvalence_lambda.zip"
}

#secrets/passwords

data "aws_secretsmanager_secret" "api_key" {
  name = "${var.environment}/api_key/nuvalence"
}
data "aws_secretsmanager_secret_version" "current_api" {
  secret_id = data.aws_secretsmanager_secret.api_key.id
}

data "aws_secretsmanager_secret" "database_pass" {
  name = "${var.environment}/database/nuvalence"
}
data "aws_secretsmanager_secret_version" "current_db" {
  secret_id = data.aws_secretsmanager_secret.database_pass.id
}

#store lambda files in lambda bucket
resource "aws_s3_object" "nuvalence_lambda" {
  bucket = var.lambda_bucket

  key    = "user_uploads.zip"
  source = data.archive_file.nuvalence_lambda.output_path

  etag = filemd5(data.archive_file.nuvalence_lambda.output_path)
}

#user_uploads.py lambda

resource "aws_lambda_function" "nuvalence_test" {
  function_name = "UserUploads"

  s3_bucket = var.lambda_bucket
  s3_key    = aws_s3_object.nuvalence_lambda.key

  runtime = "python3.9"
  handler = "user_uploads.lambda_handler"

  source_code_hash = data.archive_file.nuvalence_lambda.output_base64sha256

  role = aws_iam_role.lambda_exec_role.arn
  environment {
    variables = {
      db_user = var.database_user
      db_pass = jsondecode(data.aws_secretsmanager_secret_version.current_db.secret_string)["db_pass"]
      api_key = jsondecode(data.aws_secretsmanager_secret_version.current_api.secret_string)["api_key"]
    }
  }
}

#healthcheck lambda

resource "aws_lambda_function" "healthcheck" {
  function_name = "healthcheck"

  s3_bucket = var.lambda_bucket
  s3_key    = aws_s3_object.nuvalence_lambda.key

  runtime = "python3.9"
  handler = "user_uploads.lambda_health"

  source_code_hash = data.archive_file.nuvalence_lambda.output_base64sha256

  role = aws_iam_role.lambda_exec_role.arn
  environment {
    variables = {
      db_user = var.database_user
      db_pass = jsondecode(data.aws_secretsmanager_secret_version.current_db.secret_string)["db_pass"]
      api_key = jsondecode(data.aws_secretsmanager_secret_version.current_api.secret_string)["api_key"]
    }
  }
}

#Logging

resource "aws_cloudwatch_log_group" "nuvalence_test" {
  name = "/aws/lambda/${aws_lambda_function.nuvalence_test.function_name}"

  retention_in_days = 7
}

#Lambda Exec IAM Role and policy

resource "aws_iam_role" "lambda_exec_role" {
  name = "nuvalence_lambda"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid    = ""
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "nuvalence_lambda_policy" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}