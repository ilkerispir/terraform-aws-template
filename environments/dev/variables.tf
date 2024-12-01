variable "environment" {
  description = "What environment is it being deployed to?"
}

variable "app_name" {
  description = "What to name the application associated resources."
}

variable "region" {
  description = "AWS Region to create resources in"
  default     = "ap-southeast-2"
}

variable "role_arn" {
  description = "AWS Role ARN"
}

variable "session_name" {
  description = "AWS Session Name"
}

variable "external_id" {
  description = "AWS External ID"
}
