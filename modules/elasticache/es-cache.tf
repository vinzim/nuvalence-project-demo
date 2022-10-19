resource "aws_elasticache_cluster" "rds_cache" {
  cluster_id        = "rds-cache"
  engine            = "redis"
  node_type         = "cache.t3.micro"
  num_cache_nodes   = 1
  port              = 6379
  apply_immediately = true
  subnet_group_name = var.elasticache_subnet_group_name
  log_delivery_configuration {
    destination      = aws_cloudwatch_log_group.nuvalence_eslog.name
    destination_type = "cloudwatch-logs"
    log_format       = "text"
    log_type         = "slow-log"
  }
  log_delivery_configuration {
    destination      = aws_cloudwatch_log_group.nuvalence_eslog.name
    destination_type = "cloudwatch-logs"
    log_format       = "text"
    log_type         = "engine-log"
  }
}

resource "aws_cloudwatch_log_group" "nuvalence_eslog" {
  name              = "/aws/elasticache/"
  retention_in_days = 7
}

# CloudWatch Resources
#
resource "aws_cloudwatch_metric_alarm" "cache_cpu" {
  alarm_name          = "${aws_elasticache_cluster.rds_cache.cluster_id}-cpu-utilization"
  alarm_description   = "Redis cluster CPU utilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ElastiCache"
  period              = "300"
  statistic           = "Average"

  threshold = "75"

  alarm_actions = [var.alert_topic]
  ok_actions    = [var.alert_topic]
  depends_on    = [aws_elasticache_cluster.rds_cache]
}

resource "aws_cloudwatch_metric_alarm" "cache_memory" {
  alarm_name          = "${aws_elasticache_cluster.rds_cache.cluster_id}-freememory"
  alarm_description   = "Redis cluster freeable memory"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "FreeableMemory"
  namespace           = "AWS/ElastiCache"
  period              = "60"
  statistic           = "Average"

  threshold = "10000000"

  alarm_actions = [var.alert_topic]
  ok_actions    = [var.alert_topic]
  depends_on    = [aws_elasticache_cluster.rds_cache]
}