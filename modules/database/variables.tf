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
  description = "database name"
  type        = string
}

variable "db_admin_user" {
  description = "database administrator name"
  type        = string
}

variable "security_group_id" {
  description = "Security group ID for db"
  type        = string
}

variable "db_subnet_group_name" {
  description = "Name of the database subnet group"
  type        = string
}

variable "monitoring_enabled" {
  description = "RDS Enhanced Monitoring"
  type        = bool
}

variable "max_connections" {
  description = "Number of max connections for alerting"
  type        = number
}

variable "alert_topic" {
  description = "Alert Topic ARN"
  type        = string
}