# --- environments/prod/main.tf ---

locals {
  service_name   = "polygo"
  container_port = 8000

  tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}

# VPC + Subnet (chỉ dùng public subnet cho ECS/ALB)
module "vpc" {
  source = "../../modules/vpc"

  environment         = var.environment
  project_name        = var.project_name
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidrs = var.public_subnet_cidrs
  private_subnet_cidrs = coalesce(
    try(var.private_subnet_cidrs, []),
    []
  )
  enable_nat = false
}

# Security Groups cho ALB và ECS tasks
module "security_groups" {
  source = "../../modules/security-group"

  environment    = var.environment
  vpc_id         = module.vpc.vpc_id
  vpc_cidr_block = module.vpc.vpc_cidr_block
}

# ECR repository cho image polygo
module "ecr" {
  source = "../../modules/ecr"

  repository_name      = local.service_name
  image_tag_mutability = "MUTABLE"
  force_delete         = true
  scan_on_push         = true
  encryption_type      = "AES256"
  tags                 = local.tags
}

# CloudWatch log group cho ECS task
module "cloudwatch" {
  source = "../../modules/cloudwatch"

  log_group_name    = "/ecs/${var.environment}/${local.service_name}"
  retention_in_days = 14
  tags              = local.tags
}

# IAM roles cho ECS task/execution
module "iam" {
  source = "../../modules/iam"

  environment = var.environment
  tags        = local.tags
}

# ECS cluster
module "ecs_cluster" {
  source = "../../modules/ecs-cluster"

  name               = "${var.environment}-${var.project_name}-cluster"
  container_insights = true
  log_group_name     = module.cloudwatch.log_group_name
  tags               = local.tags
}

# ALB public
module "alb" {
  source = "../../modules/alb"

  environment       = var.environment
  project_name      = var.project_name
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  alb_sg_id         = module.security_groups.alb_sg_id
  health_check_path = "/"
}

# ECS Service Fargate cho ứng dụng polygo
module "ecs_service" {
  source = "../../modules/ecs-service"

  environment = var.environment
  service_name = local.service_name

  cluster_id   = module.ecs_cluster.cluster_id
  cluster_name = module.ecs_cluster.cluster_name
  region       = var.aws_region

  execution_role_arn = module.iam.execution_role_arn
  task_role_arn      = module.iam.task_role_arn
  log_group_name     = module.cloudwatch.log_group_name

  subnet_ids         = module.vpc.public_subnet_ids
  security_group_ids = [module.security_groups.ecs_tasks_sg_id]
  assign_public_ip   = true

  container_image = "${module.ecr.repository_url}:latest"
  container_port  = local.container_port
  cpu             = 256
  memory          = 512

  environment_variables = {
    SUPABASE_URL = var.supabase_url
    SUPABASE_KEY = var.supabase_key
  }

  desired_count      = 1
  enable_autoscaling = false
  target_group_arn   = module.alb.target_group_arn
  tags               = local.tags
}
