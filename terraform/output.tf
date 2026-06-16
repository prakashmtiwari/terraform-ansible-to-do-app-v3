output "cluster_name" {
  description = "ECS cluster name"
  value       = module.ecs.cluster_name
}

output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "public_subnets" {
  description = "Public subnet IDs"
  value       = module.vpc.public_subnets
}

output "private_subnets" {
  description = "Private subnet IDs"
  value       = module.vpc.private_subnets
}

output "route_table_ids" {
  description = "Route table IDs"
  value       = module.vpc.public_route_table_ids
}

output "region" {
  description = "AWS region"
  value       = var.aws_region
}

output "frontend_ecr_repository_uri" {
  description = "URI of the ECR repository for the frontend"
  value       = module.frontend_ecr.repository_url
}

output "backend_ecr_repository_uri" {
  description = "URI of the ECR repository for the backend"
  value       = module.backend_ecr.repository_url
}

output "alb_url" {
  description = "Public URL of the ALB"
  value       = "http://${module.alb.dns_name}"
}