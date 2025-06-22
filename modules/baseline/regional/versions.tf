terraform {
  required_version = "~> 1.7"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    awsutils = {
      source  = "cloudposse/awsutils"
      version = ">= 0.1.0"
    }
  }
}
