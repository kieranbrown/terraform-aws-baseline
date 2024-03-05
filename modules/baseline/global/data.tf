data "aws_caller_identity" "current" {}

data "aws_organizations_organization" "current" {
  provider = aws.management
}

data "aws_organizations_organizational_units" "current" {
  provider  = aws.management
  parent_id = data.aws_organizations_organization.current.roots[0].id
}
