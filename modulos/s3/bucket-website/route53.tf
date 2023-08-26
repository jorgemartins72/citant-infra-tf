resource "aws_route53_zone" "this" {
  name          = var.dominio
  force_destroy = true
}

output "dominio_primary_nameserver_website" {
  value = aws_route53_zone.this.primary_name_server
}
output "dominio_nameservers_website" {
  value = aws_route53_zone.this.name_servers
}
