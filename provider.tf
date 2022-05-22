locals {
  default_tags = {
    app        = "terraform-aws-baseline"
    managed-by = "terraform"
  }
}

provider "aws" {
  region = "us-east-1"
  alias  = "us-east-1"

  default_tags {
    tags = local.default_tags
  }
}

provider "aws" {
  region = "eu-west-2"
  alias  = "eu-west-2"

  default_tags {
    tags = local.default_tags
  }
}
