module "main_bucket" {
  source = "../secure-s3-bucket"

  name = var.name
}

resource "aws_s3_bucket_logging" "this" {
  bucket = module.main_bucket.id

  target_bucket = module.access_logs_bucket.id
  target_prefix = "/"
}

module "access_logs_bucket" {
  source = "../secure-s3-bucket"

  name = "${var.name}-access-logs"
  acl  = "log-delivery-write"

  lifecycle_rules = [
    {
      id = "auto-archive"

      transition = {
        days          = 90
        storage_class = "GLACIER"
      }
    }
  ]
}
