resource "aws_acm_certificate" "certificate_app" {
  domain_name               = var.dominio
  validation_method         = "DNS"
  subject_alternative_names = ["*.${var.dominio}"]
}

resource "aws_acm_certificate_validation" "certificate_validation_app" {
  certificate_arn         = aws_acm_certificate.certificate_app.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation_app : record.fqdn]
}

resource "aws_route53_record" "cert_validation_app" {
  for_each = {
    for dvo in aws_acm_certificate.certificate_app.domain_validation_options : dvo.domain_name => {
      name    = dvo.resource_record_name
      record  = dvo.resource_record_value
      type    = dvo.resource_record_type
      zone_id = dvo.domain_name == var.dominio
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = aws_route53_zone.app_frontend.id
}