variable "aws_region" {
}

variable "sg_name" {
  default = "rds_sg"
}

variable "identifier" {
  description = "Identifier for your DB"
}

variable "storage" {
  description = "Storage size in GB"
}

variable "engine" {
  description = "Engine type, example values mysql, postgres"
}

variable "engine_version" {
  description = "Engine version"
}

variable "instance_class" {
  description = "Instance class"
}

variable "db_name" {
  description = "db name"
}

variable "vpc_id" {
  description = "vpc id"
}


variable "subnets" {
  description = "subnets for the VPC to use when creating an internal elb"
  type        = list
}

variable "username" {
  description = "User name"
}

variable "password" {
  description = "password, provide through your ENV variables"
}
