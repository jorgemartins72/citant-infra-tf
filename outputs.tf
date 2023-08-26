
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
# output "_website_cdn_url" {
#   value = module.website.cdn_url
# }
# output "_website_distruibution_id" {
#   value = module.website.distruibution_id
# }

output "repositorio_api_container_image" {
  value = "--------------------------------------------"
}
output "repositorio_api_container_image_url" {
  value = module.repositorio_container_api.repositorio_url
}

output "repositorio_codigo_api_" {
  value = "--------------------------------------------"
}
output "repositorio_codigo_api_arn" {
  value = module.repositorio_codigo.repositorio_arn
}
output "repositorio_codigo_api_url" {
  value = module.repositorio_codigo.repositorio_url
}

output "pipeline" {
  value = "--------------------------------------------"
}
output "pipeline_codebuilder_arn" {
  value = module.pipeline_api.codebuilder_arn
}

