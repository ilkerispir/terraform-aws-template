module "vpc" {
  source                               = "terraform-aws-modules/vpc/aws"
  version                              = "5.13.0"

  name                                 = "${var.app_name}-${var.environment}-vpc"

  cidr                                 = "10.0.0.0/16"
  azs                                  = ["${var.region}a", "${var.region}b", "${var.region}c"]

  private_subnets                      = ["10.0.16.0/20", "10.0.32.0/20", "10.0.48.0/20"]
  public_subnets                       = ["10.0.64.0/20", "10.0.80.0/20", "10.0.96.0/20"]
  database_subnets                     = ["10.0.112.0/20", "10.0.128.0/20", "10.0.144.0/20"]
  elasticache_subnets                  = ["10.0.160.0/20", "10.0.176.0/20", "10.0.192.0/20"]

  enable_nat_gateway                   = true
  single_nat_gateway                   = true

  public_subnet_tags = {
    "kubernetes.io/role/elb" = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = "1"
    "karpenter.sh/discovery" = "${var.app_name}-eks-${var.environment}"
  }

  tags = {
    Terraform   = "true"
    Environment = var.environment
  }
}
