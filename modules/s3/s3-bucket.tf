### Bucket Creation
resource "aws_s3_bucket" "datastore" {
  bucket = var.datastore_bucket

  tags = {
    Name         = var.datastore_bucket
    Organization = var.Organization
  }
}

resource "aws_s3_bucket_acl" "datastore_bucket" {
  bucket = aws_s3_bucket.datastore.id
  acl    = "private"
}

### Encryption for S3

resource "aws_kms_key" "s3bucket_kms" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
}

resource "aws_s3_bucket_server_side_encryption_configuration" "s3encryption" {
  bucket = aws_s3_bucket.datastore.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.s3bucket_kms.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

### Lifecycle config

resource "aws_s3_bucket_lifecycle_configuration" "s3keep30" {
  bucket = aws_s3_bucket.datastore.id
  rule {
    id = "keep30d"
    expiration {
      days = 30
    }
    filter {}
    status = "Enabled"
  }
}


#Creation of bucket for lambda storage

resource "aws_s3_bucket" "lambda_bucket" {
  bucket = var.lambda_bucket
  tags = {
    Name         = var.lambda_bucket
    Organization = var.Organization
  }
}

resource "aws_s3_bucket_acl" "bucket_acl" {
  bucket = aws_s3_bucket.lambda_bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "s3encryption-lambda" {
  bucket = aws_s3_bucket.lambda_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.s3bucket_kms.arn
      sse_algorithm     = "aws:kms"
    }
  }
}