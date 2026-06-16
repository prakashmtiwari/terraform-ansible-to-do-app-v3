provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "to-do-app-v3"
      Environment = var.environment
      ManagedBy   = "Terraform"
    }
  }
}
