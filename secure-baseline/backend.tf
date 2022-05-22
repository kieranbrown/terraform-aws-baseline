terraform {
  backend "remote" {
    organization = "kieranbrown"

    workspaces {
      name = "terraform-aws-secure-baseline"
    }
  }
}
