module "secure_baseline" {
  source  = "nozaq/secure-baseline/aws"
  version = "1.1.0"

  audit_log_bucket_name           = "audit-logs-${data.aws_caller_identity.current.account_id}"
  aws_account_id                  = data.aws_caller_identity.current.account_id
  region                          = data.aws_region.current.name
  support_iam_role_principal_arns = [data.aws_caller_identity.current.account_id]

  # https://github.com/nozaq/terraform-aws-secure-baseline/issues/229
  alarm_sns_topic_kms_master_key_id  = "alias/aws/sns"
  config_sns_topic_kms_master_key_id = "alias/aws/sns"

  max_password_age = 90

  providers = {
    aws                = aws
    aws.ap-northeast-1 = aws.ap-northeast-1
    aws.ap-northeast-2 = aws.ap-northeast-2
    aws.ap-northeast-3 = aws.ap-northeast-3
    aws.ap-south-1     = aws.ap-south-1
    aws.ap-southeast-1 = aws.ap-southeast-1
    aws.ap-southeast-2 = aws.ap-southeast-2
    aws.ca-central-1   = aws.ca-central-1
    aws.eu-central-1   = aws.eu-central-1
    aws.eu-north-1     = aws.eu-north-1
    aws.eu-west-1      = aws.eu-west-1
    aws.eu-west-2      = aws.eu-west-2
    aws.eu-west-3      = aws.eu-west-3
    aws.sa-east-1      = aws.sa-east-1
    aws.us-east-1      = aws.us-east-1
    aws.us-east-2      = aws.us-east-2
    aws.us-west-1      = aws.us-west-1
    aws.us-west-2      = aws.us-west-2
  }
}
