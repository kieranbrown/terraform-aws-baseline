# required for terraform-aws-networking
resource "aws_ram_sharing_with_organization" "this" {
  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_organizations_organization" "this" {
  aws_service_access_principals = [
    "ram.amazonaws.com",
    "sso.amazonaws.com"
  ]

  enabled_policy_types = ["SERVICE_CONTROL_POLICY"]

  depends_on = [aws_ram_sharing_with_organization.this]
}
