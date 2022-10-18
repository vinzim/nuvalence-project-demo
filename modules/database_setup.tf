# provider "postgresql" {
#     host            = "${aws_db_instance.dev_db.address}"
#     port            = 1433
#     username        = "dev"
#     password        = "mydevpassword"
#     depends_on      = [aws_db_instance.dev_db]
# }
# # Create App User
# resource "postgresql_role" "application_role" {
#     name                = "nuvalence_test"
#     login               = true
#     password            = "myappuserpassword"
#     encrypted_password  = true
#     depends_on          = [aws_db_instance.dev_db]
# }
# # Create Database 
# resource "postgresql_database" "dev_db" {
#     name              = "mydatabase1"
#     owner             = "dev"
#     template          = "template0"
#     lc_collate        = "C"
#     connection_limit  = -1
#     allow_connections = true
#     depends_on        = [aws_db_instance.dev_db]
# }