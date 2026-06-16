module "ecs" {
  source = "terraform-aws-modules/ecs/aws"

  cluster_name = var.cluster_name

  depends_on = [aws_service_discovery_http_namespace.this]

  cluster_configuration = {
    execute_command_configuration = {
      logging = "OVERRIDE"
      log_configuration = {
        cloud_watch_log_group_name = "/aws/ecs/aws-ec2"
      }
    }
  }

  # Cluster capacity providers
  cluster_capacity_providers = ["FARGATE"]
  default_capacity_provider_strategy = {
    FARGATE = {
      weight = 100
    }
  }



 services = {
  frontend = {
    cpu    = 512
    memory = 1024
    container_definitions = {
      frontend = {
        image = "318095823928.dkr.ecr.ap-south-1.amazonaws.com/to-do-app-frontend-v3:latest"
        portMappings = [{ name = "frontend", containerPort = 3000, protocol = "tcp" }]
        environment = [
        { name = "PORT", value = "3000" },
        { name = "BACKENDHOST", value = "backend" },
        { name = "BACKENDPORT", value = "5000" }
      ]   
      }
    }
    load_balancer = {
      service = {
        target_group_arn = module.alb.target_groups["frontend"].arn
        container_name   = "frontend"
        container_port   = 3000
      }
    }

    service_connect_configuration = {
      namespace = "to-do-app-v3"
    }
    
    subnet_ids = module.vpc.private_subnets
    security_group_ids = [aws_security_group.frontend.id]

  }

  backend = {
    cpu    = 512
    memory = 1024
    container_definitions = {
      backend = {
        image = "318095823928.dkr.ecr.ap-south-1.amazonaws.com/to-do-app-backend-v3:latest"
        portMappings = [{ name = "backend", containerPort = 5000, protocol = "tcp" }]
        readonlyRootFilesystem = false
      }
    }
    service_connect_configuration = {
      namespace = "to-do-app-v3"
      service = [{
        client_alias  = { port = 5000, dns_name = "backend" }
        port_name     = "backend"
        discovery_name = "backend"
      }]
    }
    subnet_ids = module.vpc.private_subnets
    security_group_ids = [aws_security_group.backend.id]
  }
}
}


resource "aws_service_discovery_http_namespace" "this" {
  name = "to-do-app-v3"
}