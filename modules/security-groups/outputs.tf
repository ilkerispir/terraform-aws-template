# Standard 80/443 Web security group.
output "standard_web_sg" {
  value = module.standard_web_sg.security_group_id
}

# Docker Host Nodes SG
output "docker_host_sg" {
  value = module.docker_host_sg.security_group_id
}

# RDS Security Group Access.
output "rds_access_sg" {
  value = module.rds_access_sg.security_group_id
}

# EFS Security Group Access.
output "efs_access_sg" {
  value = module.efs_network_share_sg.security_group_id
}
