# tfsec:ignore:aws-s3-enable-bucket-logging
resource "aws_s3_bucket" "this" {
  # checkov:skip=CKV_AWS_18 "Ensure the S3 bucket has access logging enabled"
  # checkov:skip=CKV_AWS_144 "Ensure that S3 bucket has cross-region replication enabled"
  # checkov:skip=CKV_AWS_145 "Ensure that S3 buckets are encrypted with KMS by default"
  bucket = var.name
}

resource "aws_s3_bucket_acl" "access_log" {
  bucket = aws_s3_bucket.this.id
  acl    = var.acl
}

# todo: lifecycle policy to remove old noncurrent versions
resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id
  policy = data.aws_iam_policy_document.this.json
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# tfsec:ignore:aws-s3-encryption-customer-key
resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    id     = "expire-noncurrent"
    status = "Enabled"

    noncurrent_version_expiration {
      noncurrent_days = 90
    }
  }

  dynamic "rule" {
    for_each = var.lifecycle_rules

    content {
      id     = rule.value.id
      status = "Enabled"

      dynamic "transition" {
        for_each = try(flatten([rule.value.transition]), [])

        content {
          days          = transition.value.days
          storage_class = transition.value.storage_class
        }
      }
    }
  }
}
