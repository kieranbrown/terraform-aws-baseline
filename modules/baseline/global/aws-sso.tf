data "aws_ssoadmin_instances" "this" {
  provider = aws.management-eu-west-2
}

locals {
  sso_instance_arn      = tolist(data.aws_ssoadmin_instances.this.arns)[0]
  sso_identity_store_id = tolist(data.aws_ssoadmin_instances.this.identity_store_ids)[0]
}

data "aws_ssoadmin_permission_set" "aws_administrator_access" {
  provider = aws.management-eu-west-2

  instance_arn = local.sso_instance_arn
  name         = "AWSAdministratorAccess"
}

data "aws_identitystore_group" "aws_administrator_access" {
  provider = aws.management-eu-west-2

  identity_store_id = local.sso_identity_store_id

  alternate_identifier {
    unique_attribute {
      attribute_path  = "DisplayName"
      attribute_value = "AWSAdministratorAccess"
    }
  }
}

resource "aws_ssoadmin_account_assignment" "aws_administrator_access" {
  provider = aws.management-eu-west-2

  instance_arn       = local.sso_instance_arn
  permission_set_arn = data.aws_ssoadmin_permission_set.aws_administrator_access.arn

  principal_id   = data.aws_identitystore_group.aws_administrator_access.group_id
  principal_type = "GROUP"

  target_id   = data.aws_caller_identity.current.account_id
  target_type = "AWS_ACCOUNT"
}
