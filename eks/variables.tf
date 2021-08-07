variable "aws_region" {
  description = "region"
}

variable "aws_profile" {
  description = "profile"
}

variable "cluster_name" {
  description = "Name of the eks cluster"
}

variable "vpc_id" {
  description = "ID of the VPC to use when creating an internal elb"
}

variable "subnets" {
  description = "subnets for the VPC to use when creating an internal elb"
  type        = list
}

variable "kubeconfig_path" {
  description = "path to save kubeconfig"
}
