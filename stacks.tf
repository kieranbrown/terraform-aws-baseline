module "stack_us-east-1" {
  source = "./stack"

  providers = {
    aws = aws.us-east-1
  }
}

module "stack_eu-west-2" {
  source = "./stack"

  providers = {
    aws = aws.eu-west-2
  }
}
