variable "lambda_bucket" {
  description = "Value of the s3 bucket to contain the lambda"
  type        = string
}

variable "datastore_bucket" {
  description = "Value of the s3 bucket for the datastore"
  type        = string
}

variable "database_user" {
  description = "Value of the user for the db"
  type        = string
}

variable "environment" {
  description = "Environment to Deploy to"
  type        = string
}
