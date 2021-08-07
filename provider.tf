terraform {
  backend "s3" {
    bucket = "tradew-terraform-state"
    key    = "tradew-main.tfstate"
    region = "us-west-2"
  }
}

provider "aws" {
  profile = var.profile
  region  = var.region
}
