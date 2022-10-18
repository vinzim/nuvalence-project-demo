output "security_group_id" {
  value = module.security_group.security_group_id
}

output "database_subnets" {
  value = module.vpc.database_subnet_group_name
}

output "cloudwatch_flowlog" {
  value = module.vpc.vpc_flow_log_id
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "db_subnet_group" {
  value = module.vpc.database_subnet_group_name
}

output "elasticache_subnet_group" {
  value = module.vpc.elasticache_subnet_group_name
}