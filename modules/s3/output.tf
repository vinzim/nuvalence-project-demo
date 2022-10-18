output "datastore_bucket" {
  value = aws_s3_bucket.datastore.bucket
}
output "lambda_bucket" {
  value = aws_s3_bucket.lambda_bucket.bucket
}
