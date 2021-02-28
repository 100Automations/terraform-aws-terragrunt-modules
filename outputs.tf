output "vpc_id" {
  value = module.network.vpc_id
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

// Github Actions AWS Credentials
output "access_key_id" {
  value = module.github_action.access_key_id
}

output "secret_access_key_id" {
  value = module.github_action.secret_access_key_id
}
