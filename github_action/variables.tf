variable "tags" {
  default = { terraform_managed = "true" }
  type    = map(any)
}

variable "account_id" {
  type = string
}
