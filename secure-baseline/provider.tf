locals {
  default_tags = {
    app        = "terraform-aws-secure-baseline"
    managed-by = "terraform"
  }
}

provider "aws" {
  region = "eu-west-2"

  default_tags {
    tags = local.default_tags
  }
}

# --------------------------------------------------------------------------------------------------
# A list of providers for all AWS regions.
# Reference: https://docs.aws.amazon.com/general/latest/gr/rande.html
# --------------------------------------------------------------------------------------------------

provider "aws" {
  region = "ap-northeast-1"
  alias  = "ap-northeast-1"

  default_tags {
    tags = local.default_tags
  }
}

provider "aws" {
  region = "ap-northeast-2"
  alias  = "ap-northeast-2"

  default_tags {
    tags = local.default_tags
  }
}

provider "aws" {
  region = "ap-northeast-3"
  alias  = "ap-northeast-3"

  default_tags {
    tags = local.default_tags
  }
}

provider "aws" {
  region = "ap-south-1"
  alias  = "ap-south-1"

  default_tags {
    tags = local.default_tags
  }
}

provider "aws" {
  region = "ap-southeast-1"
  alias  = "ap-southeast-1"

  default_tags {
    tags = local.default_tags
  }
}

provider "aws" {
  region = "ap-southeast-2"
  alias  = "ap-southeast-2"

  default_tags {
    tags = local.default_tags
  }
}

provider "aws" {
  region = "ca-central-1"
  alias  = "ca-central-1"

  default_tags {
    tags = local.default_tags
  }
}

provider "aws" {
  region = "eu-central-1"
  alias  = "eu-central-1"

  default_tags {
    tags = local.default_tags
  }
}

provider "aws" {
  region = "eu-north-1"
  alias  = "eu-north-1"

  default_tags {
    tags = local.default_tags
  }
}

provider "aws" {
  region = "eu-west-1"
  alias  = "eu-west-1"

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

provider "aws" {
  region = "eu-west-3"
  alias  = "eu-west-3"

  default_tags {
    tags = local.default_tags
  }
}

provider "aws" {
  region = "sa-east-1"
  alias  = "sa-east-1"

  default_tags {
    tags = local.default_tags
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
  region = "us-east-2"
  alias  = "us-east-2"

  default_tags {
    tags = local.default_tags
  }
}

provider "aws" {
  region = "us-west-1"
  alias  = "us-west-1"

  default_tags {
    tags = local.default_tags
  }
}

provider "aws" {
  region = "us-west-2"
  alias  = "us-west-2"

  default_tags {
    tags = local.default_tags
  }
}
