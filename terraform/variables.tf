variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "ap-south-1"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
  default     = "to-do-app-cluster"
}

variable "ecs_project_name" {
  description = "Name of the ECS project"
  type        = string
  default     = "to-do-app-v3"
}

variable "ecr_frontend_repository_name" {
  description = "Name of the ECR repository for the frontend"
  type        = string
  default     = "to-do-app-frontend-v3"
}

variable "ecr_backend_repository_name" {
  description = "Name of the ECR repository for the backend"
  type        = string
  default     = "to-do-app-backend-v3"
}