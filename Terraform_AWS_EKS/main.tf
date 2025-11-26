provider "aws" {
    region = "us-west-1"
}

data "aws_vpc" "default" {
    default = true
}

data "aws_subnets" "default"{
    filter {
      name = "vpc-id"
      values = [data.aws_vpc.default.id]
    }
}

module "eks" {
  source = "./modules/eks"
  cluster_name = "demo"
  instance_type = "t2.micro"
  env = "dev"
  private_subnet = data.aws_subnets.default.ids
}



