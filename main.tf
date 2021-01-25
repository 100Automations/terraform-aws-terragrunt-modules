terraform {
  required_version = "~>0.14.5"
}

provider "aws" {
  version = "3.20.0"
  region  = var.region
}

module "network" {
  source             = "./network"
  region             = var.region
  project_name       = var.project_name
  environment        = var.environment
  cidr_block         = var.cidr_block
  availability_zones = var.availability_zones
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
  datetime     = local.datetime

  db_username = var.db_username
  db_name     = var.db_name
  db_password = var.db_password
  db_port     = var.db_port

  db_snapshot_migration = var.db_snapshot_migration
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

  // Container Variables
  container_port = var.container_port
  task_name      = local.task_name
  tags           = var.tags
}

module "ecs" {
  source = "./ecs-fargate"

  // Input from other Modules
  vpc_id                = module.network.vpc_id
  public_subnet_ids     = module.network.public_subnet_ids
  db_security_group_id  = module.rds.db_security_group_id
  alb_security_group_id = module.applicationlb.security_group_id
  alb_target_group_arn  = module.applicationlb.alb_target_group_arn

  // Input from Variables
  account_id   = var.account_id
  region       = var.region
  environment  = var.environment
  project_name = var.project_name

  // Container Variables
  desired_count    = var.desired_count
  container_memory = var.container_memory
  container_cpu    = var.container_cpu
  container_port   = var.container_port
  container_name   = local.container_name
  cluster_name     = local.cluster_name
  task_name        = local.task_name
  image_tag        = var.image_tag

  depends_on = [module.applicationlb]
}

module "r53" {
  source = "./r53"

  // Input from other Modules
  alb_external_dns  = module.applicationlb.lb_dns_name
  bastion_public_ip = module.bastion.public_ip

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
  region       = var.region
  project_name = var.project_name

  bastion_instance_type    = var.bastion_instance_type
  cron_key_update_schedule = var.cron_key_update_schedule
  github_usernames         = var.github_usernames
}

module "acm" {
  source = "./acm"

  // Input from Variables
  domain_name = var.domain_name
  // subject_alternative_names = [var.host_name]
}

module "github_action" {
  source = "./github_action"
}