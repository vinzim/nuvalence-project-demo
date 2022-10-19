data "aws_secretsmanager_secret" "database_pass" {
  name = "${var.environment}/database/nuvalence"
}
data "aws_secretsmanager_secret_version" "current" {
  secret_id = data.aws_secretsmanager_secret.database_pass.id
}

resource "aws_db_instance" "database" {
  allocated_storage                     = 50
  db_name                               = var.db_name
  engine                                = "postgres"
  engine_version                        = "14.4"
  instance_class                        = var.database_instance
  username                              = var.db_admin_user
  password                              = jsondecode(data.aws_secretsmanager_secret_version.current.secret_string)["admin_db_pass"]
  skip_final_snapshot                   = true
  allow_major_version_upgrade           = false
  storage_encrypted                     = true
  vpc_security_group_ids                = [var.security_group_id]
  maintenance_window                    = var.maintenance_window
  backup_window                         = var.backup_window
  backup_retention_period               = var.backup_retention_period
  db_subnet_group_name                  = var.db_subnet_group_name
  enabled_cloudwatch_logs_exports       = ["postgresql", "upgrade"]
  deletion_protection                   = false
  performance_insights_enabled          = var.monitoring_enabled
  performance_insights_retention_period = var.monitoring_enabled ? 7 : null
}

# CloudWatch Resources
#
resource "aws_cloudwatch_metric_alarm" "max_connections" {
  alarm_name          = "${aws_db_instance.database.db_name}-max-connections"
  alarm_description   = "Max Connection DB Threshold"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "DatabaseConnections"
  namespace           = "AWS/RDS"
  period              = "300"
  statistic           = "Average"

  threshold = var.max_connections

  alarm_actions = [var.alert_topic]
  ok_actions    = [var.alert_topic]
  depends_on    = [aws_db_instance.database]
}