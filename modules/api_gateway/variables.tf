variable "lambda_function" {
    description = "lambda function details"
}

variable "lambda_exec" {
    description = "lambda execution details"
}

variable "alert_topic" {
  description = "Alert Topic ARN"
  type = string
}

variable "health_function" {
    description = "health function details"
}