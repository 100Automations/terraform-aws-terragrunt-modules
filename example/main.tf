terraform {
  required_version = "~>0.14.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }

  backend "s3" {
    bucket         = "codeforcalifornia"
    key            = "terraform-state/foodoasis/dev/terraform.tfstate"
    region         = "us-west-1"
    dynamodb_table = "terraform-locks"
  }
}

provider "aws" {
  region = var.region
}

module "terraform-aws-terragrunt-modules" {
  source = "../"

  // General
  account_id   = var.account_id
  project_name = var.project_name
  environment  = var.environment
  region       = var.region

  // DNS
  domain_name = var.domain_name
  host_names  = var.host_names
  // bastion_hostname = "bastion.foodoasis.net"

  tags = var.tags

  // Elastic Container Service
  default_alb_url = var.default_alb_url

  // Elastic Container Service
  ecs_ec2_instance_count = var.ecs_ec2_instance_count
  key_name               = var.key_name

  // Database
  db_name               = var.db_name
  db_password           = var.db_password
  db_username           = var.db_username
  db_port               = var.db_port
  db_snapshot_migration = var.db_snapshot_migration
}

module "full-stack" {
  source = "../service-client"

  // Input Variables
  account_id   = var.account_id
  project_name = var.project_name
  environment  = var.environment
  region       = var.region
  host_name    = var.host_name
  tags         = var.tags

  // Container Variables
  desired_count      = var.full_stack_desired_count
  container_image    = var.full_stack_container_image
  container_cpu      = var.full_stack_container_cpu
  container_memory   = var.full_stack_container_memory
  container_port     = var.full_stack_container_port
  container_env_vars = var.full_stack_container_env_vars
  container_env_secrets = var.full_stack_container_env_secrets
  health_check_path  = var.full_stack_health_check_path

  // Input from module
  vpc_id                 = module.terraform-aws-terragrunt-modules.vpc_id
  cluster_id             = module.terraform-aws-terragrunt-modules.cluster_id
  cluster_name           = module.terraform-aws-terragrunt-modules.cluster_name
  alb_https_listener_arn = module.terraform-aws-terragrunt-modules.alb_https_listener_arn
}