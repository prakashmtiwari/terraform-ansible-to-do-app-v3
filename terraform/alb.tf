module "alb" {
  source  = "terraform-aws-modules/alb/aws"

  name    = "${var.cluster_name}-alb"
  vpc_id  = module.vpc.vpc_id
  subnets = module.vpc.public_subnets

  security_groups = [aws_security_group.alb.id]

  listeners = {
    http = {
      port     = 80
      protocol = "HTTP"

      forward = {
        target_group_key = "frontend"
      }
    }
  }

  target_groups = {
    frontend = {
      name_prefix = "front"

      protocol    = "HTTP"
      port        = 3000
      target_type = "ip"

      create_attachment = false

      health_check = {
        enabled             = true
        path                = "/"
        protocol            = "HTTP"
        matcher             = "200-399"
        healthy_threshold   = 2
        unhealthy_threshold = 2
      }
    }
  }
}



