terraform {
  required_version = "~>0.14.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {
    bucket         = "codeforcalifornia"
    key            = "terraform-state/foodoasis/dev/terraform.tfstate"
    region         = "us-west-1"
    dynamodb_table = "terraform-locks"
  }
}

module "network" {
  source = "./network"

  // Input from Variables
  region       = var.region
  project_name = var.project_name
  environment  = var.environment
  vpc_cidr     = var.vpc_cidr
  tags         = var.tags
}

module "rds" {
  source = "./rds"

  // Input from other modules
  vpc_id                    = module.network.vpc_id
  vpc_cidr                  = module.network.vpc_cidr
  private_subnet_ids        = module.network.private_subnet_ids
  private_subnet_cidrs      = module.network.private_subnet_cidrs
  bastion_security_group_id = module.bastion.security_group_id

  // Input from Variables
  project_name = var.project_name
  environment  = var.environment
  region       = var.region

  db_username           = var.db_username
  db_name               = var.db_name
  db_password           = var.db_password
  db_port               = var.db_port
  db_snapshot_migration = var.db_snapshot_migration

  tags = var.tags
}

module "applicationlb" {
  source = "./applicationlb"

  // Input from other Modules
  vpc_id              = module.network.vpc_id
  public_subnet_ids   = module.network.public_subnet_ids
  acm_certificate_arn = module.acm.acm_certificate_arn

  // Input from Variables
  account_id   = var.account_id
  region       = var.region
  environment  = var.environment
  project_name = var.project_name
  default_alb_url = var.default_alb_url

  tags = var.tags
}

module "ecs" {
  source = "./ecs"

  // Input from other Modules
  vpc_id                = module.network.vpc_id
  vpc_cidr              = module.network.vpc_cidr
  public_subnet_ids     = module.network.public_subnet_ids
  alb_security_group_id = module.applicationlb.security_group_id

  // Input from Variables
  environment            = var.environment
  project_name           = var.project_name
  ecs_ec2_instance_count = var.ecs_ec2_instance_count
  key_name               = var.key_name

  tags = var.tags

  depends_on = [module.applicationlb]
}

module "r53" {
  source = "./r53"

  // Input from other Modules
  alb_external_dns = module.applicationlb.lb_dns_name
  // bastion_public_ip = module.bastion.public_ip

  // Input from Variables
  domain_name = var.domain_name
  host_names  = var.host_names
}

module "bastion" {
  source = "./bastion"

  // Input from other Modules
  vpc_id            = module.network.vpc_id
  public_subnet_ids = module.network.public_subnet_ids

  // Input from Variables
  account_id   = var.account_id
  project_name = var.project_name
  environment  = var.environment

  bastion_instance_type    = var.bastion_instance_type
  cron_key_update_schedule = var.cron_key_update_schedule
  bastion_github_file      = var.bastion_github_file

  tags = var.tags
}

module "acm" {
  source = "./acm"

  // Input from Variables
  domain_name = var.domain_name

  tags = var.tags
}

module "github_action" {
  source = "./github_action"

  account_id = var.account_id

  tags = var.tags
}
