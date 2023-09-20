resource "aws_route53_zone" "app_frontend" {
  name          = var.dominio
  force_destroy = true
}

output "dominio_primary_nameserver_app" {
  value = aws_route53_zone.app_frontend.primary_name_server
}
output "dominio_nameservers_app" {
  value = aws_route53_zone.app_frontend.name_servers
}
