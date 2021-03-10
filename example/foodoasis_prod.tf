module "full-stack" {
  source = "../service-client"

  // Input Variables
  account_id   = var.account_id
  project_name = var.project_name
  environment  = var.environment
  region       = var.region
  vpc_cidr     = var.vpc_cidr
  tags         = var.tags

  # URLs that will route the this application
  # Useful if there is a front-end vs backend or multiple applications within the same infrastrucutre
  host_names         = ["aws-test-la.foodoasis.net", "aws-test-hi.foodoasis.net", "aws-test-ca.foodoasis.net"]
  // Container Variables
  application_type = "fullstack"
  launch_type       = "FARGATE"
  desired_count     = 3
  container_image   = "foodoasisla/foodoasisla:1.0.44"
  container_cpu     = 0
  container_memory  = 256
  container_port    = 5000
  health_check_path = "/"

  # Lives in a variable to keep it secret
  container_env_vars = var.foodoasis_prod_env_vars

  // Input from module
  vpc_id                 = module.terraform-aws-terragrunt-modules.vpc_id
  public_subnet_ids      = module.terraform-aws-terragrunt-modules.public_subnet_ids
  cluster_id             = module.terraform-aws-terragrunt-modules.cluster_id
  cluster_name           = module.terraform-aws-terragrunt-modules.cluster_name
  alb_https_listener_arn = module.terraform-aws-terragrunt-modules.alb_https_listener_arn
  alb_security_group_id  = module.terraform-aws-terragrunt-modules.alb_security_group_id
  task_execution_role_arn = module.terraform-aws-terragrunt-modules.task_execution_role_arn
}

variable "foodoasis_prod_env_vars" {
  description = "Envrionment variables for the application, this can include sensitive secrets. Do not hardcode in .tf files"
  type        = map(string)
  default = {
    "foo" : "bar"
  }
}