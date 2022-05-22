resource "aws_iam_openid_connect_provider" "github_actions" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
}

module "github_actions_iam_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version = "~> 5.0"

  create_role      = true
  role_name        = "github-actions"
  role_policy_arns = ["arn:aws:iam::aws:policy/AdministratorAccess"]
  provider_url     = "https://token.actions.githubusercontent.com"

  oidc_fully_qualified_subjects = [
    "repo:kieranbrown/aws-acm-validator:ref:refs/heads/main",
  ]
}
