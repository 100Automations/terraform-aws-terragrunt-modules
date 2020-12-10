variable account_id {
  description = "AWS Account ID"
}

variable region {
  type    = string
  default = "us-east-2"
}

variable vpc_id {
  description = "VPC ID"
}

variable public_subnet_ids {
  description = "public subnet ids for where to place bastion"
  type        = list(string)
}

variable bastion_name {
  type = string
}

variable bastion_instance_type {
  description = "The ec2 instance type of the bastion server"
  default     = "t2.micro"
}

variable cron_key_update_schedule {
  default     = "5,0,*,* * * * *"
  description = "The cron schedule that public keys are synced from the bastion s3 bucket to the server; default to once every hour"
}

variable github_usernames {
  description = "the name of the public key files in ./public_keys without the file extension; example ['alice', 'bob', 'carol']"
}

variable "enable_hourly_cron_updates" {
  default = "false"
}

variable "ssh_user" {
  default = "ubuntu"
}

variable "allowed_security_groups" {
  type        = list(string)
  default     = []
  description = "A list of Security Group ID's to allow access to."
}

variable "keys_update_frequency" {
  default = ""
}

variable "allowed_cidr" {
  type = list(string)

  default = [
    "0.0.0.0/0",
  ]

  description = "A list of CIDR Networks to allow ssh access to."
}

variable "allowed_ipv6_cidr" {
  type = list(string)

  default = [
    "::/0",
  ]

  description = "A list of IPv6 CIDR Networks to allow ssh access to."
}