output "lambda_function" {
  value = aws_lambda_function.nuvalence_test
}
output "lambda_exec_role" {
  value = aws_iam_role.lambda_exec_role
}

output "lambda_health" {
  value = aws_lambda_function.healthcheck
}