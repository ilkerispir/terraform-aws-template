terraform {
  required_version = ">= 1.5.4"

  required_providers {
    aws = {
      version               = ">= 5.6.2"
      configuration_aliases = [aws.us_east_1]
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.6"
    }
  }

  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "ilkerispir"

    workspaces {
      name = "terraform-aws-template"
    }
  }
}
