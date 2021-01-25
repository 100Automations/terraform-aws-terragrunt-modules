locals {
  envname = "${var.project_name}-${var.environment}"
}

variable "account_id" {
  type        = number
  description = "AWS Account ID"
}

variable "project_name" {
  type        = string
  description = "The overall name of the project using this infrastructure; used to group related resources by"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "region" {
  type = string
}

variable "environment" {
  type = string
}

variable "tags" {
  default = { terraform_managed = "true" }
  type    = map(any)
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "Public Subnets for which the ALB will be associated with"
}

variable "acm_certificate_arn" {
  type        = string
  description = "Certificate to use for HTTPS listener"
}