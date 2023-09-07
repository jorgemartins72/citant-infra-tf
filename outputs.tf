
output "__app_dns__primario" {
  value = module.app_frontend.dominio_primary_nameserver_app
}
output "__app_dns_" {
  value = module.app_frontend.dominio_nameservers_app
}
# output "__app_cdn_url" {
#   value = module.app_frontend.cdn_url
# }
# output "__app_distruibution_id" {
#   value = module.app_frontend.distruibution_id
# }

output "__website_dns__" {
  value = "--------------------------------------------"
}
output "_website_dns__primario" {
  value = module.website.dominio_primary_nameserver_website
}
output "_website_dns_" {
  value = module.website.dominio_nameservers_website
}

output "ecr" {
  value = "--------------------------------------------"
}
output "ecr-api" {
  value = module.cluster_ecs.ecr_api_repository_url
}
output "ecr-worker" {
  value = module.cluster_ecs.ecr_worker_repository_url
}

output "codecommit" {
  value = "--------------------------------------------"
}
output "codecommit_api_url" {
  value = module.cluster_ecs.codecommit_api_url
}
output "codecommit_worker_url" {
  value = module.cluster_ecs.codecommit_worker_url
}

