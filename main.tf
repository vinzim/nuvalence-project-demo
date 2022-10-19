module "s3" {
  source           = "./modules/s3"
  datastore_bucket = var.datastore_bucket
  Organization     = var.Organization
  lambda_bucket    = var.lambda_bucket
}

module "networking" {
  source = "./modules/networking"
}

module "pg-db" {
  security_group_id       = module.networking.security_group_id
  source                  = "./modules/database"
  database_password       = var.database_password
  database_instance       = var.database_instance
  backup_window           = var.backup_window
  maintenance_window      = var.maintenance_window
  backup_retention_period = var.backup_retention_period
  environment             = var.environment
  db_admin_user           = var.db_admin_user
  db_name                 = var.db_name
  db_subnet_group_name    = module.networking.db_subnet_group
  monitoring_enabled      = var.monitoring_enabled
  alert_topic             = module.sns.alert_topic
  max_connections         = var.max_connections
}

module "lambda" {
  source           = "./modules/lambda"
  lambda_bucket    = module.s3.lambda_bucket
  datastore_bucket = module.s3.datastore_bucket
  database_user    = var.database_user
  environment      = var.environment
}

module "api_gateway" {
  depends_on = [
    module.lambda
  ]
  source          = "./modules/api_gateway"
  lambda_function = module.lambda.lambda_function
  lambda_exec     = module.lambda.lambda_exec_role
  alert_topic     = module.sns.alert_topic
  health_function = module.lambda.lambda_health
}

module "elasticache" {
  source                        = "./modules/elasticache"
  elasticache_subnet_group_name = module.networking.elasticache_subnet_group
  alert_topic                   = module.sns.alert_topic
}

module "sns" {
  source         = "./modules/sns"
  alerting_email = var.alerting_email
}