# --- environments/prod/outputs.tf ---

output "alb_dns_name" {
  description = "Public DNS của ALB"
  value       = module.alb.alb_dns_name
}

output "ecr_repository_url" {
  description = "ECR repo cho image polygo"
  value       = module.ecr.repository_url
}

output "ecs_cluster_name" {
  description = "Tên ECS cluster"
  value       = module.ecs_cluster.cluster_name
}

output "ecs_service_name" {
  description = "Tên ECS service"
  value       = module.ecs_service.service_name
}
