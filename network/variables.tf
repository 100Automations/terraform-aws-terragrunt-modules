locals {
  envname = "${var.project_name}-${var.environment}"
}

variable "region" {
  type = string
}

variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "vpc_cidr" {
  default = "10.10.0.0/16"
  type    = string
}

variable "tags" {
  default = { terraform_managed = "true" }
  type    = map(any)
}