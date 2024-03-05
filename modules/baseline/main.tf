data "aws_region" "current" {}

module "global" {
  source = "./global"
  count  = data.aws_region.current.name == "us-east-1" ? 1 : 0

  providers = {
    aws                      = aws
    aws.management           = aws.management
    aws.management-eu-west-2 = aws.management-eu-west-2
  }
}

module "regional" {
  source = "./regional"
  count  = 1
}
