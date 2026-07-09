terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.53.0"
    }
  }
  backend "s3" {
    bucket = "dcnh"
    region = "us-east-1"
    key = "08-07-statefiles-BASTION"
    use_lockfile = true
    encrypt = true 
  }
}

provider "aws" {
  region = "us-east-1"
}