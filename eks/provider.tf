provider "aws" {
  profile = "personal"
  region  = var.aws_region
}

data "aws_availability_zones" "available" {}

provider "http" {}

provider "helm" {
  version     = "~> 1.1.1"
  helm_driver = "configmap"
  debug       = true
}

provider "kubernetes" {
  config_path    = "~/.kube/config"
}