// --------------------------
// Global/General Variables
// --------------------------
variable "account_id" {
  type        = string
  description = "AWS Account ID"
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
  default = ""
}

variable "host_names" {
  description = "The URL where the application will be hosted, must be a subdomain of the domain_name"
  type        = list(string)
  default = [""]
}

variable "key_name" {
  type        = string
  description = "Pre-created SSH Key to use for ECS EC2 Instance"
}

variable "bastion_hostname" {
  type        = string
  description = "The hostname bastion, must be a subdomain of the domain_name"
}

variable "vpc_cidr" {
  type        = string
  default     = "10.10.0.0/16"
  description = "The range of IP addresses this vpc will reside in"
}

// --------------------------
// ALB Variable
// --------------------------
variable "default_alb_url" {
  type        = string
  description = "Default URL to forward the user if there is no ALB route rules that match"
}

// --------------------------
// ECS/Fargat Variables
// --------------------------
variable "ecs_ec2_instance_count" {
  type    = number
  default = 0
}

// --------------------------
// RDS/Database Variables
// --------------------------
variable "create_db_instance" {
  type        = string
  description = "Flag to create DB Instace"
  default = "false"
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
  default = 5432
}

variable "db_engine_version" {
  description = "the database major and minor version of postgres"
}

variable "db_major_version" {
  description = "the database major version for postgres"
}

variable "db_snapshot_migration" {
  type        = string
  description = "Name of snapshot that will used to for new database, must be the same region as var.region"
  default     = ""
}

// --------------------------
// Bastion Module Variables
// --------------------------
variable "bastion_instance_type" {
  description = "The ec2 instance type of the bastion server"
  default     = "t2.micro"
}

variable "bastion_github_file" {
  description = "the file located in Github for where the allowed github users will live"
  type        = map(any)
}
