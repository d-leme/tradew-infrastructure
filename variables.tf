variable "namespace" {
  description = "name of the stack being deployed"
}

variable "profile" {
  default = "personal"
  description = "aws profile"
}

variable "region" {
  description = "aws region"
}

variable "rds_username" {
  description = "username, provide through your ENV variables"
}

variable "rds_password" {
  description = "password, provide through your ENV variables"
}

variable "kubeconfig_path" {
  description = "path to kubeconfig file"
}
