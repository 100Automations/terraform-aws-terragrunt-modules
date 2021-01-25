# terraform-aws-terragrunt-modules
# Under construction - github.com/darpham
Deploys a RDS instance running postgres 11 into a private VPC, with an ssh
bastion host for secure access.

You might use this for creating the backend for a webapp.

## Overview
This repository contains all the necessary modules needed to create the following resources in AWS.

1. VPC (Virtual Private Cloud), including subnets, route tables, igw

2. RDS Database instance, Postgres 11 within the private subnet 

3. Bastion server securely accessing the database or other services

4. ALB (Application Load Balancer) for handing routing and SSL

5. ECS (Elastice Container Service) cluster, using EC2 instances as the capacity provider

6. Your applications, as deployed using task & container defintions as services on the ECS Cluster

7. ACM Certificate to enable HTTPs/SSL for your application

8. Route 53 (DNS), only available if the domain is also hosted in R53
    - CNAME record for ALB
    - A record for Bastion server

9. IAM user to enable Github Actions for CI/CD

## Requirements

1. AWS access/credentials
    - It's reccommeneded to have Administrator access to ensure proper permisions
    - [Documentation](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html)

2. Binaries
    - [Terraform >=v0.14](https://www.terraform.io/downloads.html)

3. Terraform State and Lock files requires pre-created resources [Documentation](https://www.terraform.io/docs/language/settings/backends/s3.html)
    - S3 Bucket for storing state file
    - DynamoDB Table for storing lock files (recommended default: terraform-locks)
    - see examples folder for how to properly set

## Example

See examples folder

## Inputs
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| project\_name | The overall name of the project using this infrastructure; used to group related resources by | `string` | `""` | yes |
| account\_id | the aws account id # that this is provisioned into | `string` | `""` | yes |
| stage | a short name describing the lifecyle or stage of development that this is running for; ex: 'dev', 'qa', 'prod', 'test'| `string` | `"dev"` | no |
| region | the aws region code where this is deployed; ex: 'us-west-2', 'us-east-1', 'us-east-2'| `string` | `""` | yes |
| cidr\_block |The range of IP addresses this vpc will reside in| `string` | `"10.10.0.0/16"` | no |
| availability_zones |The region + identifiers for the zones that the vpc will cover. Ex: ['us-west-2a', 'us-west-2b', 'us-west-2c']. Varies between regions.| `string` | `""` | yes |
| tags| key value map of tags applied to infrastructure | `map` | `{terraform_managed = "true"}` | no |
| db\_username | The name of the default postgres user created by RDS when the instance is booted| `string` | `""` | yes |
| db\_name |The name of the default postgres database created by RDS when the instance is booted | `string` | `""` | yes |
| db\_password |The postgres database password created for the default database when the instance is booted. :warning: do not put this into git!| `string` | `""` | yes |
| ssh\_public\_key\_names |the name of the public key files in ./public_keys without the file extension; example ['alice', 'bob', 'carol']| `list(string)` | `""` | yes |

## Bastion server
A [bastion server](https://docs.aws.amazon.com/quickstart/latest/linux-bastion/overview.html)
is a hardened server through which access to resources running in private
subnets of a VPC. An example use case is a database. Rather than create a
database with ports open to the whole wide Internet we can create it within our
own virtual cloud, and grant access to it via the bastion, aka "jumpbox", server.

To grant users access via the bastion to VPC resources add the user's Github Username to the file you marked as input. A cron job is configured to run to retrieve the user's key and create their account on the bastion server.
Supply the file via the input: var.bastion_github_file.
example:
variable "bastion_github_file"  = {
    github_repo_owner = "100Automations",
    github_repo_name  = "terraform-aws-terragrunt-modules",
    github_branch     = "main",
    github_filepath   = "bastion_github_users",
}
``` bash
# List of Github Users allowed to access the bastion server
# 
darpham
# END OF FILE
```

SSH command:
```bash
ssh -i ~/.ssh/<user-private-github-key> <user-github-name>@<bastion-ip>
```

# TODO
- [ ] Update Inputs
- [ ] ...
