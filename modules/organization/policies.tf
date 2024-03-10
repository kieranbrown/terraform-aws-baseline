locals {
  enabled_regions = ["eu-west-2", "us-east-1"]
}

data "aws_iam_policy_document" "deny_regions" {
  statement {
    effect    = "Deny"
    actions   = ["*"]
    resources = ["*"]

    condition {
      test     = "StringNotEquals"
      variable = "aws:RequestedRegion"
      values   = local.enabled_regions
    }
  }
}

resource "aws_organizations_policy" "deny_regions" {
  name    = "deny-regions"
  content = data.aws_iam_policy_document.deny_regions.json
}

resource "aws_organizations_policy_attachment" "deny_regions" {
  policy_id  = aws_organizations_policy.deny_regions.id
  target_id  = aws_organizations_organization.this.roots[0].id
  depends_on = [aws_organizations_organization.this]
}

// This is required for using the "aws_organizations_organization" data source to programatically list accounts
resource "aws_organizations_resource_policy" "list_accounts" {
  content = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "*"
        },
        "Action" : [
          "organizations:DescribeOrganization",
          "organizations:ListAWSServiceAccessForOrganization",
          "organizations:ListAccounts",
          "organizations:ListRoots"
        ],
        "Resource" : "*",
        "Condition" : {
          "StringEquals" : {
            "aws:PrincipalOrgID" : aws_organizations_organization.this.id
          }
        }
      }
    ]
  })
}
