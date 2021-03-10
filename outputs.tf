output "vpc_id" {
  value = module.network.vpc_id
}

output "public_subnet_ids" {
  value = module.network.public_subnet_ids
}

output "cluster_id" {
  value = module.ecs.cluster_id
}

output "cluster_name" {
  value = module.ecs.cluster_name
}

output "alb_https_listener_arn" {
  value = module.applicationlb.alb_https_listener_arn
}

output "alb_security_group_id" {
  value = module.applicationlb.security_group_id
}

// Github Actions AWS Credentials
output "access_key_id" {
  value = module.github_action.access_key_id
}

output "secret_access_key_id" {
  value = module.github_action.secret_access_key_id
}

output "task_execution_role_arn" {
  value = module.ecs.task_execution_role_arn
}