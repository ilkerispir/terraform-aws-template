variable "app_name" {
  description = "App name"
}

variable "environment" {
  description = "The current environment"
}

variable "instance_type" {
  description = "AWS EC2 Instance Type"
}

variable "eks_cluster_version" {
  description = "AWS EKS Cluster Version"
}

variable "vpc_id" {
  description = "ID of the VPC to apply these rules to."
}

variable "private_subnets" {
  description = "Private subnet range for the hosts to deploy to."
}

variable "public_subnets" {
  description = "Public-facing subjects with direct IGW Access."
}

variable "region" {
  description = "AWS Region"
}
