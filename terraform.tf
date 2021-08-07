module "vpc" {
  source = "./vpc"

  namespace = var.namespace
}

# # rename DB to inventory DB
# module "rds" {
#   source = "./rds"

#   identifier     = "inventory-write-db"
#   storage        = "10"
#   engine         = "postgres"
#   engine_version = "9.6.8"
#   instance_class = "db.t2.micro"
#   db_name        = "inventory-write-db"

#   username = var.rds_username
#   password = var.rds_password

#   aws_region = var.region
#   vpc_id     = module.vpc.id
#   subnets    = module.vpc.subnets
# }

module "eks" {
  source = "./eks"

  aws_region = var.region
  aws_profile = var.profile

  cluster_name = "${var.namespace}-eks-cluster"

  vpc_id  = module.vpc.id
  subnets = module.vpc.subnets

  kubeconfig_path = var.kubeconfig_path
}


