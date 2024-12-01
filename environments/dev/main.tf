# Default provider
provider "aws" {
  region = var.region

  assume_role {
    role_arn     = var.role_arn
    session_name = var.session_name
    external_id  = var.external_id
  }
}

provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"

  assume_role {
    role_arn     = var.role_arn
    session_name = var.session_name
    external_id  = var.external_id
  }
}

module "vpc" {
  source      = "../modules/vpc"
  app_name    = var.app_name
  environment = var.environment
  region      = var.region
}

module "security_groups" {
  source         = "../modules/security-groups"
  environment    = var.environment
  vpc_id         = module.vpc.vpc_id
  vpc_cidr_block = module.vpc.vpc_cidr_block
}

module "eks" {
  source              = "../modules/eks"
  app_name            = var.app_name
  environment         = var.environment
  instance_type       = "t4g.medium"
  eks_cluster_version = "1.30"

  vpc_id              = module.vpc.vpc_id
  public_subnets      = module.vpc.public_subnets
  private_subnets     = module.vpc.private_subnets
  region              = var.region
}

module "ilker-app" {
  source                      = "../applications/ilker-app"
  app_name                    = var.app_name
  environment                 = var.environment
}
