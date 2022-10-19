resource "aws_apigatewayv2_api" "user_uploads_api" {
  name          = "nuvalence_lambda_gateway"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "user_uploads" {
  api_id = aws_apigatewayv2_api.user_uploads_api.id

  name        = "nuvalence_lambda_stage"
  auto_deploy = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_gw.arn

    format = jsonencode({
      requestId               = "$context.requestId"
      sourceIp                = "$context.identity.sourceIp"
      requestTime             = "$context.requestTime"
      protocol                = "$context.protocol"
      httpMethod              = "$context.httpMethod"
      resourcePath            = "$context.resourcePath"
      routeKey                = "$context.routeKey"
      status                  = "$context.status"
      responseLength          = "$context.responseLength"
      integrationErrorMessage = "$context.integrationErrorMessage"
      }
    )
  }
}

resource "aws_apigatewayv2_integration" "lambda" {
  api_id = aws_apigatewayv2_api.user_uploads_api.id

  integration_uri    = var.lambda_function.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}


resource "aws_apigatewayv2_integration" "lambda_health" {
  api_id = aws_apigatewayv2_api.user_uploads_api.id

  integration_uri    = var.health_function.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "user_uploads" {
  api_id = aws_apigatewayv2_api.user_uploads_api.id

  route_key = "GET /hello"
  target    = "integrations/${aws_apigatewayv2_integration.lambda.id}"
}

resource "aws_apigatewayv2_route" "health" {
  api_id = aws_apigatewayv2_api.user_uploads_api.id

  route_key = "GET /health"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_health.id}"
}

resource "aws_cloudwatch_log_group" "api_gw" {
  name = "/aws/api_gw/${aws_apigatewayv2_api.user_uploads_api.name}"

  retention_in_days = 7
}

resource "aws_lambda_permission" "api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function.arn
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.user_uploads_api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "health_check_api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.health_function.arn
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.user_uploads_api.execution_arn}/*/*"
}
resource "aws_route53_health_check" "api_gateway" {
  depends_on = [
    aws_apigatewayv2_api.user_uploads_api, aws_apigatewayv2_integration.lambda
  ]
  fqdn              = "${replace(aws_apigatewayv2_api.user_uploads_api.api_endpoint,"https://","")}"
  port              = 80
  type              = "HTTPS"
  resource_path     = "nuvalence_lambda_stage/health"
  failure_threshold = "5"
  request_interval  = "30"
  cloudwatch_alarm_name = aws_cloudwatch_metric_alarm.api_gateway_status.alarm_name
  reference_name = "${aws_apigatewayv2_api.user_uploads_api.name}"
}

resource "aws_cloudwatch_metric_alarm" "api_gateway_status" {
  alarm_name          = "${aws_apigatewayv2_api.user_uploads_api.api_endpoint} health check"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "5"
  metric_name         = "HealthCheckStatus"
  namespace           = "AWS/Route53"
  period              = "60"
  statistic           = "Minimum"
  threshold           = "1.0"
  alarm_description   = "monitors api_gateway"
  alarm_actions = [var.alert_topic]
  ok_actions    = [var.alert_topic]
}