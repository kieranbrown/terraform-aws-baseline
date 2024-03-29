terraform {
  required_version = "~> 1.7"

  required_providers {
    aws = {
      source                = "hashicorp/aws"
      version               = "~> 5.0"
      configuration_aliases = [aws, aws.management, aws.management-eu-west-2]
    }
  }
}
