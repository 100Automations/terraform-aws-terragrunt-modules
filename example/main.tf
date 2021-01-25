terraform {
  backend "s3" {
    bucket         = ""
    key            = "terraform.tfstate"
    region         = "us-west-1"
    dynamodb_table = "terraform-locks"
  }
}

module "terraform-aws-terragrunt-modules" {
  source = "../"

}

module "frontend" {
  source = "../service-client"

}

module "backend" {
  source = "../service-api"

}