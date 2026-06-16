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

terraform {
  backend "s3" {
    bucket         = "to-do-app-terraform-state"
    key            = "to-do-app/terraform.tfstate"
    region         = "ap-south-1"
    use_lockfile     = true
    encrypt        = true
  }
}