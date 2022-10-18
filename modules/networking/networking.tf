module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.0"

  name = "base_vpc"
  cidr = "10.99.0.0/18"
  azs = ["use1-az1", "use1-az2"]
  public_subnets   = ["10.99.0.0/24","10.99.1.0/24"]
  private_subnets  = ["10.99.3.0/24","10.99.4.0/24"]
  database_subnets = ["10.99.7.0/24","10.99.8.0/24"]
  create_database_subnet_group       = true
  create_database_subnet_route_table = true
  create_elasticache_subnet_group = true
  create_flow_log_cloudwatch_log_group = true
}


module "security_group"  {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.0"

  name        = "postgresql"
  description = "PostgreSQL security group"
  vpc_id      = module.vpc.vpc_id

  # ingress
  ingress_with_cidr_blocks = [
    {
      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
      description = "PostgreSQL access from within VPC"
      cidr_blocks = module.vpc.vpc_cidr_block
    },
  ]
}

# module "security_group"  {
#   source  = "terraform-aws-modules/security-group/aws"
#   version = "~> 4.0"

#   name        = "postgresql"
#   description = "PostgreSQL security group"
#   vpc_id      = module.vpc.vpc_id

#   # ingress
#   ingress_with_cidr_blocks = [
#     {
#       from_port   = 5432
#       to_port     = 5432
#       protocol    = "tcp"
#       description = "lambda access from within VPC"
#       cidr_blocks = module.vpc.vpc_cidr_block
#     },
#   ]
# }