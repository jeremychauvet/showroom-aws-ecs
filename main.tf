module "ghost" {
  source  = "terraform-aws-modules/ecs/aws"
  version = "5.9.1"

  cluster_name = "ghost"

  cluster_configuration = {
    execute_command_configuration = {
      logging = "OVERRIDE"
      log_configuration = {
        cloud_watch_log_group_name = "/aws/ecs/aws-ec2"
      }
    }
  }

  fargate_capacity_providers = {
    FARGATE = {
      default_capacity_provider_strategy = {
        weight = 50
      }
    }
    FARGATE_SPOT = {
      default_capacity_provider_strategy = {
        weight = 50
      }
    }
  }

  services = {
    ghost = {
      cpu    = 1024
      memory = 4096

      # Container definition(s)
      container_definitions = {
        server = {
          cpu                = 512
          memory             = 1024
          essential          = true
          image              = "public.ecr.aws/docker/library/ghost:5.80"
          memory_reservation = 50
        }
      }

      service_connect_configuration = {
        namespace = "ghost"
        service = {
          client_alias = {
            port     = 80
            dns_name = "ghost"
          }
          port_name      = "ghost"
          discovery_name = "ghost"
        }
      }

      # load_balancer = {
      #   service = {
      #     target_group_arn = "arn:aws:elasticloadbalancing:eu-west-1:1234567890:targetgroup/bluegreentarget1/209a844cd01825a4"
      #     container_name   = "ghost"
      #     container_port   = 80
      #   }
      # }

      subnet_ids = local.network.subnet_ids
      # security_group_rules = {
      #   alb_ingress_3000 = {
      #     type                     = "ingress"
      #     from_port                = 80
      #     to_port                  = 80
      #     protocol                 = "tcp"
      #     description              = "Service port"
      #     source_security_group_id = "sg-12345678"
      #   }
      #   egress_all = {
      #     type        = "egress"
      #     from_port   = 0
      #     to_port     = 0
      #     protocol    = "-1"
      #     cidr_blocks = ["0.0.0.0/0"]
      #   }
      # }
    }
  }

  tags = {
    Environment = "Production"
    ManagedBy   = "Terraform"
  }
}
