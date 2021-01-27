terraform {
  backend "s3" {
    bucket         = "codeforcalifornia"
    key            = "terraform-state/foodoasis/dev/terraform.tfstate"
    region         = "us-west-1"
    dynamodb_table = "terraform-locks"
  }
}

module "terraform-aws-terragrunt-modules" {
  source = "../"


  bastion_hostname = var.bastion_host_name
}

// module "frontend" {
//   source = "../service-client"

// }

// module "backend" {
//   source = "../service-api"

// }
