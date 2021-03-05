locals {
  env_vars = [
    for k, v in var.container_env_vars : {
      "name" : k,
      "value" : v
    }
  ]

  # Conditional Intellegience for container compute resources
  # 0 CPU means unlimited cpu access
  # 0 memory is invalid, thus it defaults to 128mb
  container_memory = var.container_memory == 0 ? 128 : var.container_memory
  task_memory = var.container_memory == 0 ? 128 : var.container_memory
  task_cpu = var.container_cpu == 0 ? null : var.container_cpu
}

resource "aws_ecs_task_definition" "task" {
  family = local.task_definition_family

  container_definitions = templatefile(
    "${path.module}/templates/task-definition.json",
    {
      container_memory      = local.container_memory
      container_cpu         = var.container_cpu
      container_port        = var.container_port
      container_name        = local.container_name
      image                 = var.container_image
      container_env_vars    = jsonencode(local.env_vars)
    }
  )

  requires_compatibilities = ["EC2"]
  network_mode             = "bridge"
  execution_role_arn       = "arn:aws:iam::470363915259:role/foodoasis_task_execution" #must be pre-created
  memory                   = local.task_memory
  cpu                      = local.task_cpu
}

resource "aws_ecs_service" "svc" {
  name            = local.envname
  cluster         = var.cluster_id
  task_definition = aws_ecs_task_definition.task.arn
  launch_type     = "EC2"
  desired_count   = var.desired_count

  load_balancer {
    container_name   = local.container_name
    container_port   = var.container_port
    target_group_arn = aws_lb_target_group.this.arn
  }

  depends_on = [aws_lb_target_group.this, aws_lb_listener_rule.static]
  lifecycle {
    ignore_changes = [task_definition]
  }
}

resource "aws_lb_target_group" "this" {
  name                 = "${local.envname}-tg"
  port                 = 80
  protocol             = "HTTP"
  vpc_id               = var.vpc_id
  deregistration_delay = 90
  stickiness {
    type = "lb_cookie"
  }
  health_check {
    interval            = 15
    healthy_threshold   = 3
    unhealthy_threshold = 2
    matcher             = "200,302"
  }
}

resource "aws_lb_listener_rule" "static" {
  listener_arn = var.alb_https_listener_arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }

  condition {
    host_header {
      values = var.host_names
    }
  }

  depends_on = [aws_lb_target_group.this]
}
