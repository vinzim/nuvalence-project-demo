resource "aws_sns_topic" "alert_topic" {
  name = "sns-alert-topic"
}

resource "aws_sns_topic_subscription" "alerting_email" {
  topic_arn = aws_sns_topic.alert_topic.arn
  protocol  = "email"
  endpoint  = var.alerting_email
}
  