variable "project" {
    default = "roboshop"
    type = string
}

variable "environment" {
    default = "dev"
    type = string
}

variable "vpc_cidr_block" {
    default = "10.0.0.0/16"
    type = string
}

variable "az" {
    default = [ "us-east-1a", "us-east-1b" ]
    type = list(string)
}

variable "public_subnet_cidr_block" {
    default = [ "10.0.1.0/24", "10.0.2.0/24" ]
    type = list(string)
}

variable "private_subnet_cidr_block" {
    default = [ "10.0.11.0/24", "10.0.12.0/24" ]
    type = list(string)
}

variable "database_subnet_cidr_block" {
    default = [ "10.0.21.0/24", "10.0.22.0/24" ]
    type = list(string)
}