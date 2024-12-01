output "vpc_cidr_block" {
  value = module.vpc.vpc_cidr_block
  description = "CIDR Block of available IP Address ranges."
}

output "private_subnets_cidr_blocks" {
  value = module.vpc.private_subnets_cidr_blocks
  description = "CIDR Block of available IP Address ranges."
}

output "vpc_id" {
  value = module.vpc.vpc_id
  description = "Main VPC ID"
}

output "public_subnets" {
  value = module.vpc.public_subnets
  description = "List of public subnets."
}

output "private_subnets" {
  value = module.vpc.private_subnets
  description = "List of private subnets."
}

output "public_route_tables" {
  value = module.vpc.public_route_table_ids 
  description = "Public route tables created."
}

output "private_route_table_ids" {
  value = module.vpc.private_route_table_ids
  description = "Private route tables created."
}

output "database_subnets" {
  value = module.vpc.database_subnets
  description = "List of subnets dedicated for database instances."
}
