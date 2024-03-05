data "aws_organizations_organization" "this" {}

resource "aws_organizations_organizational_unit" "this" {
  for_each = toset(["Infrastructure", "Sandbox", "Workloads"])

  name = each.key

  parent_id = sensitive(data.aws_organizations_organization.this.roots[0].id)
}

resource "aws_organizations_account" "this" {
  for_each = {
    Management = {}
    Networking = {
      organizational_unit = "Infrastructure"
    }
    Sandbox = {
      organizational_unit = "Sandbox"
    }
  }

  name  = each.key
  email = sensitive(lookup(each.value, "email", format(var.email_spec, lower(each.key))))

  iam_user_access_to_billing = "ALLOW"

  parent_id = try(sensitive(aws_organizations_organizational_unit.this[each.value.organizational_unit].id), null)

  lifecycle {
    ignore_changes = [iam_user_access_to_billing]
  }
}
