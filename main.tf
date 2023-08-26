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

module "repositorio_container_api" {
  source  = "./modulos/repositorio_container/api"
  projeto = var.projeto
}

module "repositorio_codigo" {
  source  = "./modulos/repositorio_codigo/api"
  projeto = var.projeto
}

module "pipeline_api" {
  source          = "./modulos/pipeline/api"
  tagname         = var.tagname
  repositorio_url = module.repositorio_codigo.repositorio_url
  repositorio_arn = module.repositorio_codigo.repositorio_arn
  docker_username = var.docker_username
  docker_userpass = var.docker_userpass
}

module "cluster_ecs" {
  source              = "./modulos/ecs"
  tagname             = var.tagname
  projeto             = var.projeto
  image_url           = "${module.repositorio_container_api.repositorio_url}:latest"
  taskdefinition_name = "${var.projeto}-taskdefinition-api"
  container_name      = "${var.projeto}-api"
}


