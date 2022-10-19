# nuvalence-project-demo
## Setup and Run Terraform
- Export sa_terraform variables for AWS

```EXPORT AWS_ACCESS_KEY_ID=<ACCESSKEYID>```\
```EXPORT AWS_SECRET_ACCESS_KEY=<SECRETKEY>```

- Create the following secrets in secrets manager:

``` /ENV/database/nuvalence with the key/value admin_dbpass:PASSWORD``` \
``` /ENV/database/nuvalence with the key/value dbpass:PASSWORD``` \
``` ${var.environment}/api_key/nuvalence with the key/value api_key:CLIENT_API_KEY```

- Run the terraform apply including the environment variables file:

```terraform apply -var-file=environments/ENV.tfvars```

## Set up the Postgres Table and User
- Allow your IP address on the Postgres Security Group for access to the postgres server. 
  - TODO: create an EC2 to run the postgres script. That calls the secrets manager variables and imports them into the script
- Export the admin password as PGPASSWORD
- Copy the Password from /ENV/database/nuvalence with the key/value dbpass:PASSWORD for the user password and update postgres.sql with it
- Run the command:
```postgres_scripts/pg_setup.sh RDSHOSTNAME```
- This will create the table and User


## Modules:

Api_gateway: Contains the api_gateway terraform code to deploy the User endpoint, and lambda integrations, alerting, logging, and endpoint monitoring

Routes include: /hello and /health

Database: Deploys a Postgres RDS Database with logging and Alerting

Elasticache: Deploys a single elasticache node with logging, and alerting. This will be used as a cache for the RDS Database

Lambda: Deploys 2 lambda which are triggered from api_gateway. They include a health check and a hello integration, Logging, and an Exec role and policy.

Networking: Includes a VPC setup using cidr 10.99.0/0/18 in us-east-1, as well as the RDS Security group

S3: Creates S3 buckets for the datastore, and a lambda storage. This has a lifecycle policy of 30 days, acls, and is encrypted with an aws:kms key

SNS: Creates an SNS Topic and subscription for alerting