locals {
  envname                = "${var.project_name}-${var.environment}"
  ecs_service_name       = "${local.envname}-service"
  task_definition_family = "${local.envname}-td"
  task_name              = "${local.envname}-task"
  container_name         = "${local.envname}-container"
}

// --------------------------
// Global/General Variables
// --------------------------
variable "account_id" {
  description = "AWS Account ID"
}

variable "project_name" {
  description = "The overall name of the project using this infrastructure; used to group related resources by"
}

variable "region" {
  type = string
}

variable "environment" {
  type = string
}

variable "host_name" {
  type = string
}

variable "vpc_id" {
  description = "VPC ID"
}

variable "tags" {
  default = { terraform_managed = "true" }
  type    = map(any)
}

// --------------------------
// ECS Cluster
// --------------------------

variable "cluster_id" {
  type = string
}

variable "cluster_name" {
  type = string
}

// --------------------------
// Application Load Balancer
// --------------------------

variable "health_check_path" {
  type    = string
  default = "/"
}

variable "alb_https_listener_arn" {
  description = "ALB https listener arn for adding rule to"
}

// --------------------------
// Container Definition Variables
// --------------------------

variable "desired_count" {
  default = 1
  type    = number
}

variable "container_image" {
  type = string
}

variable "container_cpu" {
  type    = number
  default = 0
}

variable "container_memory" {
  type    = number
  default = 0
}

variable "container_port" {
  type    = number
  default = 80
}

variable "container_env_vars" {
  type = map(string)
}

variable "container_env_secrets" {
  type = map(string)
}