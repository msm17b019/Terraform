terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.15.1"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc"
  cidr = "10.0.0.0/16"

  azs            = ["ap-south-1b"]
  public_subnets = ["10.0.1.0/24"]
}

resource "aws_instance" "test-server" {
  subnet_id = module.vpc.public_subnets[0]
  ami           = "ami-05ba3a39a75be1ec4"
  instance_type = "t2.micro"
}