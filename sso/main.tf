data "aws_ssoadmin_instances" "this" {}

locals {
  instance_arn      = tolist(data.aws_ssoadmin_instances.this.arns)[0]
  identity_store_id = tolist(data.aws_ssoadmin_instances.this.identity_store_ids)[0]
}

resource "aws_ssoadmin_permission_set" "administrator" {
  instance_arn = local.instance_arn
  name         = "AWSAdministratorAccess"
}

resource "aws_ssoadmin_managed_policy_attachment" "administrator" {
  instance_arn       = local.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.administrator.arn
  managed_policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_identitystore_group" "administrator" {
  display_name      = "AWSAdministratorAccess"
  description       = "Administrator access to all AWS accounts in the organization"
  identity_store_id = local.identity_store_id
}

resource "aws_identitystore_user" "me" {
  identity_store_id = local.identity_store_id

  display_name = "Kieran Brown"
  user_name    = "kieran.brown"

  emails {
    value = "kswb96@gmail.com"
  }

  name {
    given_name  = "Kieran"
    family_name = "Brown"
  }

  timezone = "Europe/London"
}

resource "aws_identitystore_group_membership" "me_administrator" {
  identity_store_id = local.identity_store_id
  group_id          = aws_identitystore_group.administrator.group_id
  member_id         = aws_identitystore_user.me.user_id
}
