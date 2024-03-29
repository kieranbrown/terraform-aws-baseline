locals {
  account_vars = try(read_terragrunt_config("account.hcl"), read_terragrunt_config(find_in_parent_folders("account.hcl")))
  region_vars  = try(read_terragrunt_config("region.hcl"), read_terragrunt_config(find_in_parent_folders("region.hcl")))

  aws_account_id  = try(local.account_vars.locals.aws_account_id, read_terragrunt_config(find_in_parent_folders("accounts.hcl")).dependency.accounts.outputs.accounts[local.account_vars.locals.aws_account_name].id)
  aws_region      = local.region_vars.locals.aws_region
  aws_assume_role = try(local.account_vars.locals.aws_assume_role, "arn:aws:iam::${local.aws_account_id}:role/OrganizationAccountAccessRole")

  default_tags = {
    "kb:name"       = "terraform-aws-baseline"
    "kb:env"        = "prod"
    "kb:managed-by" = "terraform"
  }
}

remote_state {
  backend = "s3"

  config = merge(
    {
      bucket         = "terraform-${local.aws_account_id}-${local.aws_region}-tfstate"
      key            = "terraform-aws-baseline/${path_relative_to_include()}/terraform.tfstate"
      region         = local.aws_region
      encrypt        = true
      dynamodb_table = "terraform-tfstate"
    },
    local.aws_assume_role == null ? {} : {
      assume_role = {
        role_arn = local.aws_assume_role
      }
    }
  )
}

generate "backend" {
  path      = "backend.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  backend "s3" {}
}
EOF
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
%{ for provider in ["aws", "awsutils"] }
provider "${provider}" {
  region = "${local.aws_region}"

%{ if local.aws_assume_role != null }
  assume_role {
    role_arn = "${local.aws_assume_role}"
  }
%{ endif }

  default_tags {
    tags = ${jsonencode(local.default_tags)}
  }
}

provider "${provider}" {
  alias  = "management"
  region = "${local.aws_region}"

  default_tags {
    tags = ${jsonencode(local.default_tags)}
  }
}

%{ for region in ["eu-west-2", "us-east-1"] }
provider "${provider}" {
  alias  = "management-${region}"
  region = "${region}"

  default_tags {
    tags = ${jsonencode(local.default_tags)}
  }
}
%{ endfor }
%{ endfor }
EOF
}

generate "versions" {
  path      = "versions.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  required_version = "~> 1.7"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    awsutils = {
      source = "cloudposse/awsutils"
      version = ">= 0.1.0"
    }
  }
}
EOF
}
