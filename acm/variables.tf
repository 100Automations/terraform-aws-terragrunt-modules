variable "domain_name" {
  type        = string
  description = "The domain name where the application will be deployed, must already live in AWS"
}

variable "tags" {
  default = { terraform_managed = "true" }
  type    = map(any)
}
