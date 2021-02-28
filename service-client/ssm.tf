// Save DB parameters into SSM for use by Task Definition
resource "aws_ssm_parameter" "env_secrets" {
  for_each = var.container_env_secrets

  name        = "/${var.project_name}/${var.environment}/${each.key}"
  description = "${local.envname} environment secrets"
  type        = "SecureString"
  value       = each.value
  overwrite   = true

  tags = var.tags
}
