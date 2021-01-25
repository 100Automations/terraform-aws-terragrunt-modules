// --------------------------
// Global/General Variables
// --------------------------
variable "account_id" {
  type        = string
  description = "AWS Account ID"
}

variable "namespace" {
  type        = string
  description = "Namespace, which could be your organization name or abbreviation, e.g. 'eg' or 'cp'"
}

variable "region" {
  type = string
}

variable "project_name" {
  type        = string
  description = "The overall name of the project using this infrastructure; used to group related resources by"
}

variable "environment" {
  type = string
}

variable "tags" {
  default = { terraform_managed = "true" }
  type    = map(any)
}

variable "domain_name" {
  type        = string
  description = "The domain name where the application will be deployed, must already live in AWS"
}

variable "host_names" {
  type        = string
  description = "The URL where the application will be hosted, must be a subdomain of the domain_name"
}

variable "bastion_hostname" {
  type        = string
  description = "The A record for bastion, must be a subdomain of the domain_name"
}

variable "cidr_block" {
  type        = string
  default     = "10.10.0.0/16"
  description = "The range of IP addresses this vpc will reside in"
}


// --------------------------
// ECS/Fargat Variables
// --------------------------
variable "container_cpu" {
  type    = number
  default = 256
}

variable "container_memory" {
  type    = number
  default = 512
}

variable "container_port" {
  type = number
}

variable "health_check_path" {
  type    = string
  default = "/health"
}

variable "image_tag" {
  description = "tag to be used for elastic container repositry image"
  default     = "latest"
}

variable "desired_count" {
  default = 1
  type    = number
}

// --------------------------
// RDS/Database Variables
// --------------------------
variable "db_name" {
  type        = string
  description = "Name of the Database"
}
variable "db_username" {
  type        = string
  description = "Databse Username"
}
variable "db_password" {
  type        = string
  description = "Databse Password"
}

variable "db_port" {
  type        = number
  description = "Databse Port"
}

// DB Migration Variables (Under construction)
variable "db_snapshot_migration" {
  type        = string
  description = "Name of snapshot that will used to for new database, must be the same region as var.region"
  default     = ""
}

// --------------------------
// Bastion Module Variables
// --------------------------
variable "bastion_name" {}

variable "bastion_instance_type" {
  description = "The ec2 instance type of the bastion server"
  default     = "t2.micro"
}

variable "cron_key_update_schedule" {
  default     = "5,0,*,* * * * *"
  description = "The cron schedule that public keys are synced from the bastion s3 bucket to the server; default to once every hour"
}

variable "bastion_github_file" {
  description = "the file located in Github for where the allowed github users will live"
  type        = map(any)
  default = {
    github_repo_owner = "codeforsanjose",
    github_repo_name  = "Infrastructure",
    github_branch     = "main",
    github_filepath   = "bastion_github_users",
  }
}