locals {
  networking_assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [{
      "Effect" : "Allow",
      "Action" : "sts:AssumeRole",
      "Principal" : {
        "AWS" : "*" # checkov:skip=CKV_AWS_60
      },
      "Condition" : {
        "ForAnyValue:StringEquals" : {
          "aws:PrincipalOrgPaths" : "${join("/", [
            data.aws_organizations_organization.current.id,
            data.aws_organizations_organization.current.roots[0].id,
            one([for unit in data.aws_organizations_organizational_units.current.children : unit.id if unit.name == "Infrastructure"])
          ])}/"
        }
        "StringEquals" : {
          "aws:PrincipalOrgID" : data.aws_organizations_organization.current.id
        }
      }
    }]
  })
}

# trivy:ignore:avd-aws-0057
resource "aws_iam_role" "terraform_aws_networking_dns_manager" {
  name = "terraform-aws-networking-dns-manager"

  inline_policy {
    name = "allow-managing-dns"
    policy = jsonencode({
      "Version" : "2012-10-17",
      "Statement" : [{
        "Effect" : "Allow", # todo: run IAM access analyzer on this
        "Action" : ["acm:*", "route53:*", "route53domains:*"],
        "Resource" : "*"
      }]
    })
  }

  assume_role_policy = local.networking_assume_role_policy
}

# trivy:ignore:avd-aws-0057
resource "aws_iam_role" "terraform_aws_networking_tagger" {
  name = "terraform-aws-networking-tagger"

  inline_policy {
    name = "allow-tagging"
    policy = jsonencode({
      "Version" : "2012-10-17",
      "Statement" : [{
        "Effect" : "Allow",
        "Action" : ["ec2:CreateTags", "ec2:DeleteTags"],
        "Resource" : "*"
      }]
    })
  }

  assume_role_policy = local.networking_assume_role_policy
}
