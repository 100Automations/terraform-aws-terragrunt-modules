resource "aws_ecs_task_definition" "task" {
  family = local.task_definition_family

  container_definitions = templatefile(
    "${path.module}/templates/container-definition.json",
    {
      container_memory   = var.container_memory == 0 ? 128 : var.container_memory
      container_cpu      = var.container_cpu
      container_port     = var.container_port
      container_name     = local.container_name
      image              = var.container_image
      container_env_vars = jsonencode(var.container_env_vars)
    }
  )

  requires_compatibilities = ["EC2"]
  network_mode             = "bridge"
  memory                   = var.container_memory == 0 ? null : var.container_memory
  cpu                      = var.container_cpu == 0 ? null : var.container_cpu
}

resource "aws_ecs_service" "svc" {
  name            = local.envname
  cluster         = var.cluster_id
  task_definition = aws_ecs_task_definition.task.arn
  launch_type     = "EC2"
  desired_count   = var.desired_count

  service_registries {
    registry_arn   = aws_service_discovery_service.sd_service.arn
    container_name = local.container_name
    container_port = var.container_port
  }

  depends_on = [aws_service_discovery_service.sd_service]
}
