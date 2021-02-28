// --------------------------
// Container Variables
// --------------------------
variable "host_name" {
  type = string
  description = "The URL the application will be deployed"
}

variable "full_stack_desired_count" {
  type = number
}

variable "full_stack_container_image" {
  description = "tag to be used for elastic container repositry image"
  type = string
}

variable "full_stack_container_cpu" {
  type    = number
  default = 256
}

variable "full_stack_container_memory" {
  type    = number
  default = 512
}

variable "full_stack_container_port" {
  type = number
}

variable "full_stack_health_check_path" {
  type = string
  default = "/"
}

variable "full_stack_container_env_vars" {
  type = map(string)
  default = { 
    "foo": "bar"
  }
}

variable "full_stack_container_env_secrets" {
  type = map(string)
  default = { 
    "foo": "bar"
  }
}
