variable "datastore_bucket" {
  description = "Value of the datatore bucket"
  type        = string
}

variable "Organization" {
  description = "Value of the Organization"
  type        = string
}

variable "database_instance" {
  description = "Instance used for the database"
  type        = string
}

variable "environment" {
  description = "Environment to Deploy to"
  type        = string
}

variable "database_password" {
  description = "password for database"
  type        = string
  sensitive   = true
}

variable "maintenance_window" {
  description = "Maintenance Window (RDS)"
  type        = string
}

variable "backup_window" {
  description = "Backup Window (RDS)"
  type        = string
}

variable "backup_retention_period" {
  description = "Days to keep RDS Backups"
  type        = number
}

variable "db_name" {
  description = "database Name"
  type        = string
}

variable "db_admin_user" {
  description = "database administrator name"
  type        = string
}

variable "database_user" {
  description = "database user name"
  type        = string
}

variable "lambda_bucket" {
  description = "Value of the s3 bucket to contain the lambda"
  type        = string
}

variable "monitoring_enabled" {
  description = "RDS Enhanced Monitoring"
  type        = bool
}

variable "alerting_email" {
  description = "email for alerts"
}

variable "max_connections" {
  description = "Number of max connections for alerting"
  type        = number
}