module "vpc" {
  source = "../../modules/vpc"

  environment          = var.environment
  project_name         = var.project_name
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  enable_nat           = false
}

locals {
  common_tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}
