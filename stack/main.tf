# infrastructure here is deployed to multiple regions

module "serverless_deployments_bucket" {
  source = "../modules/audited-s3-bucket"

  name = "serverless-deployments-${data.aws_caller_identity.current.account_id}-${data.aws_region.current.name}"
}
