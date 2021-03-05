variable "domain_name" {
  description = "The domain name where the application will be deployed, must already live in AWS"
  type        = string
}

variable "host_names" {
  description = "The URL where the application will be hosted, must be a subdomain of the domain_name"
  type        = list(string)
}

variable "alb_external_dns" {
  description = "Application Load Balancer External A Record for R53 Record"
  type        = string
}

variable "bastion_public_ip" {
  description = "Public IP of bastion server"
  type        = string
}

variable "bastion_hostname" {
  type        = string
  description = "The hostname bastion, must be a subdomain of the domain_name"
}
