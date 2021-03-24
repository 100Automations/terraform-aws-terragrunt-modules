locals {
  envname = "${var.project_name}-${var.environment}"
}

// --------------------------
// Global/General Variables
// --------------------------
variable "account_id" {
  description = "AWS Account ID"
}

variable "project_name" {
  type        = string
  description = "The overall name of the project using this infrastructure; used to group related resources by"
}

variable "environment" {
  type = string
}

variable "domain_name" {
  type        = string
  description = "The domain name where the application will be deployed, must already live in AWS"
}

variable "vpc_id" {
  description = "VPC ID"
}

variable "tags" {
  default = { terraform_managed = "true" }
  type    = map(any)
}

// --------------------------
// Bastion Instance Variables
// --------------------------
variable "bastion_hostname" {
  type        = string
  description = "The hostname bastion, must be a subdomain of the domain_name"
}

variable "bastion_instance_type" {
  description = "The ec2 instance type of the bastion server"
  default     = "t2.micro"
}

variable "public_subnet_ids" {
  description = "public subnet ids for where to place bastion"
  type        = list(string)
}

variable "key_name" {
  description = "SSH key to be added as the default AMI user"
  type        = string
  default     = ""
}

// --------------------------
// user_data.sh Variables
// --------------------------
variable "ssh_user" {
  default = "ubuntu"
}

variable "bastion_github_file" {
  type = map(string)
  default = {
    github_repo_owner = "codeforsanjose",
    github_repo_name  = "Infrastructure",
    github_branch     = "main",
    github_filepath   = "bastion_github_users",
  }
}

variable "additional_user_data_script" {
  default = ""
}