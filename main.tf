terraform {
  required_version = "1.5.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.13.1"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.4.0"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

module "vpc" {
  source  = "./modulos/vpc"
  tagname = var.tagname
  projeto = var.projeto
}

module "app_frontend" {
  source  = "./modulos/s3/bucket-app-frontend"
  dominio = var.dominio_app_frontend
}

module "website" {
  source  = "./modulos/s3/bucket-website"
  dominio = var.dominio_website
}

# module "repositorio_container_api" {
#   source  = "./modulos/repositorio_container/api"
#   projeto = var.projeto
# }

# module "repositorio_codigo" {
#   source  = "./modulos/repositorio_codigo/api"
#   projeto = var.projeto
# }

module "sqs" {
  source  = "./modulos/sqs"
  projeto = var.projeto
  tagname = var.tagname
}

module "cloudwatch" {
  source   = "./modulos/cloudwatch"
  sqs_name = module.sqs.sqs_name
}

module "cluster_ecs" {
  docker_username         = var.docker_username
  docker_userpass         = var.docker_userpass
  source                  = "./modulos/ecs"
  tagname                 = var.tagname
  projeto                 = var.projeto
  dominio                 = var.dominio_website
  subnets                 = module.vpc.subnets
  security_group_id       = module.vpc.security_group_id
  website_zone_id         = module.website.dominio_website_zone_id
  vpc_id                  = module.vpc.vpc_id
  website_certificado_arn = module.website.website_certificado_arn
  sqs_name                = module.sqs.sqs_name
}

# resource "aws_cloudwatch_metric_alarm" "teste" {
#   alarm_name = "AlarmeFilaAAA"
# }

# resource "aws_appautoscaling_policy" "imported" {
#   name = "PoliticaTesteUP"
# }

# import {
#   to = aws_appautoscaling_policy.imported
#   id = "citant-service-discovery-namespace/arn:aws:ecs:us-east-1:532911710482:service/CITANT-CLUSTER/CITANT-WORKER-Service/0/PoliticaUP"
# }
# output "worker_service_" {
#   value = aws_appautoscaling_policy.imported
# }
# terraform import aws_appautoscaling_policy.imported CITANT-CLUSTER/CITANT-WORKER-Service/scalable-dimension/policy-name