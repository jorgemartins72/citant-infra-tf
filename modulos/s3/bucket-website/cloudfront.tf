# resource "aws_cloudfront_origin_access_identity" "this" {
#   comment = var.dominio
# }

# resource "aws_cloudfront_distribution" "this" {
#   enabled             = true
#   comment             = "Site ${var.dominio}"
#   default_root_object = "index.html"
#   #   is_ipv6_enabled     = true

#   default_cache_behavior {
#     allowed_methods  = ["HEAD", "GET", "OPTIONS"]
#     cached_methods   = ["HEAD", "GET"]
#     target_origin_id = aws_s3_bucket.this.bucket_regional_domain_name

#     forwarded_values {
#       query_string = false
#       headers      = ["Origin"]
#       cookies {
#         forward = "none"
#       }
#     }

#     viewer_protocol_policy = "redirect-to-https"
#     min_ttl                = 0
#     default_ttl            = 3600
#     max_ttl                = 86400
#   }

#   origin {
#     domain_name = aws_s3_bucket.this.bucket_regional_domain_name
#     origin_id   = aws_s3_bucket.this.bucket_regional_domain_name
#     s3_origin_config {
#       origin_access_identity = aws_cloudfront_origin_access_identity.this.cloudfront_access_identity_path
#     }
#   }

#   aliases = [var.dominio, "www.${var.dominio}"]

#   restrictions {
#     geo_restriction {
#       restriction_type = "none"
#     }
#   }

#   viewer_certificate {
#     cloudfront_default_certificate = true
#     acm_certificate_arn            = aws_acm_certificate.this.arn
#     ssl_support_method             = "sni-only"
#   }

#   tags = {
#     Info = "Site ${var.dominio}"
#   }
# }


# resource "aws_route53_record" "cloudfront_domain" {
#   depends_on = [aws_cloudfront_distribution.this]
#   name       = var.dominio
#   zone_id    = aws_route53_zone.this.id
#   type       = "A"

#   alias {
#     evaluate_target_health = false
#     name                   = aws_cloudfront_distribution.this.domain_name
#     zone_id                = aws_cloudfront_distribution.this.hosted_zone_id
#   }
# }

# resource "aws_route53_record" "www_cloudfront_domain" {
#   depends_on = [aws_cloudfront_distribution.this]
#   name       = "www.${var.dominio}"
#   zone_id    = aws_route53_zone.this.id
#   type       = "A"

#   alias {
#     evaluate_target_health = false
#     name                   = aws_cloudfront_distribution.this.domain_name
#     zone_id                = aws_cloudfront_distribution.this.hosted_zone_id
#   }
# }

# output "cdn_url" {
#   value = aws_cloudfront_distribution.this.domain_name
# }
# output "distruibution_id" {
#   value = aws_cloudfront_distribution.this.id
# }