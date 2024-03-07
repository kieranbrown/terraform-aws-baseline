data "aws_organizations_organization" "current" {}

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
            "aws:PrincipalOrgID" : data.aws_organizations_organization.current.id
          }
        }
      }
    ]
  })
}
