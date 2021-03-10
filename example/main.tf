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
  account_id         = var.account_id
  project_name       = var.project_name
  environment        = var.environment
  region             = var.region

  // DNS
  domain_name      = var.domain_name
  host_names       = var.host_names
  bastion_hostname = var.bastion_hostname

  tags = var.tags

  // Elastic Container Service
  default_alb_url = var.default_alb_url

  // Elastic Container Service
  ecs_ec2_instance_count = var.ecs_ec2_instance_count
  key_name               = var.key_name

  // Database
  db_password           = var.db_password
  db_username           = var.db_username
  db_port               = var.db_port
  db_snapshot_migration = var.db_snapshot_migration
}
