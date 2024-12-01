variable "environment" {
  description = "What is the current environment?"
}

variable "vpc_id" {
  description = "ID of the VPC to apply these rules to."
}

variable "vpc_cidr_block" {
  description = "The VPC Cidr Block of the internal network."
}
