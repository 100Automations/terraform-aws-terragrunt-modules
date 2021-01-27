// General
account_id   = 470363915259
project_name = "foodoasis"
environment  = "dev"
region       = "us-west-1"

// DNS
domain_name = "foodoasis.net"
host_names  = ["aws-test.foodoasis.net"]
// bastion_hostname = "bastion.foodoasis.net"

tags = { terraform_managed = "true" }

// Elastic Container Service
ecs_ec2_instance_count = 1
key_name               = "fo-us-west-1-kp"

// Database

db_port               = 5432
db_snapshot_migration = "terraform-migration-1"

// Container
health_check_path = "/health"
container_port    = 5000
