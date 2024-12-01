# View all available string-based security group rules here: 
# https://github.com/terraform-aws-modules/terraform-aws-security-group/blob/master/rules.tf

# Generic Web Server Security group, allows 80/443.
module "standard_web_sg" {
  source              = "terraform-aws-modules/security-group/aws"
  name                = "${var.environment}-standard-web-sg"
  description         = "Allow basic web traffic."
  vpc_id              = var.vpc_id
  ingress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules        = ["all-all"]
  ingress_rules       = ["http-80-tcp", "https-443-tcp"]
}

module "efs_network_share_sg" {
  source              = "terraform-aws-modules/security-group/aws"
  name                = "${var.environment}-efs-share-access-sg"
  description         = "Allow access to the EFS Share."
  vpc_id              = var.vpc_id
  ingress_cidr_blocks = [var.vpc_cidr_block]
  egress_rules        = ["all-all"]
  ingress_rules       = ["nfs-tcp"]
}

# Allow docker hosts to be proxied by the load balancer.
module "docker_host_sg" {
  source              = "terraform-aws-modules/security-group/aws"
  name                = "${var.environment}-docker-host-sg"
  description         = "Allow proxying of hosts via a load balancer. Used for Docker container hosts via ECS."
  vpc_id              = var.vpc_id
  ingress_cidr_blocks = [var.vpc_cidr_block]
  egress_rules        = ["all-all"]
  ingress_rules       = ["ssh-tcp"]
  # Allow traffic from the Load Balancer Security Group.
  computed_ingress_with_source_security_group_id = [
    {
      rule                     = "all-all"
      source_security_group_id = module.standard_web_sg.security_group_id
    }
  ]
  number_of_computed_ingress_with_source_security_group_id = 1
}

# Give access to instances for accessing RDS on the local network.
module "rds_access_sg" {
  source              = "terraform-aws-modules/security-group/aws"
  name                = "${var.environment}-rds-access-sg"
  description         = "Allow access via standard RDS ports of 5432."
  vpc_id              = var.vpc_id
  ingress_cidr_blocks = [var.vpc_cidr_block]
  ingress_rules       = ["postgresql-tcp"]
  egress_rules        = ["all-all"]
}
