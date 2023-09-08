resource "aws_cloudfront_origin_access_identity" "origin_access_identity_app" {
  comment = var.dominio
}

resource "aws_cloudfront_distribution" "distribution_app" {
  enabled             = true
  comment             = "App ${var.dominio}"
  default_root_object = "index.html"
  #   is_ipv6_enabled     = true

  logging_config {
    include_cookies = true
    bucket          = aws_s3_bucket.log-app.bucket_domain_name
    prefix          = "cdn/"
  }

  default_cache_behavior {
    allowed_methods  = ["HEAD", "GET", "OPTIONS"]
    cached_methods   = ["HEAD", "GET"]
    target_origin_id = aws_s3_bucket.bucket_app.bucket_regional_domain_name

    forwarded_values {
      query_string = false
      headers      = ["Origin"]
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  origin {
    domain_name = aws_s3_bucket.bucket_app.bucket_regional_domain_name
    origin_id   = aws_s3_bucket.bucket_app.bucket_regional_domain_name
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity_app.cloudfront_access_identity_path
    }
  }

  aliases = [var.dominio, "www.${var.dominio}"]

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
    acm_certificate_arn            = aws_acm_certificate.certificate_app.arn
    ssl_support_method             = "sni-only"
  }

  tags = {
    Info = "App ${var.dominio}"
  }
}

resource "aws_route53_record" "app_cloudfront_domain" {
  depends_on = [aws_cloudfront_distribution.distribution_app]
  name       = var.dominio
  zone_id    = aws_route53_zone.this.id
  type       = "A"

  alias {
    evaluate_target_health = false
    name                   = aws_cloudfront_distribution.distribution_app.domain_name
    zone_id                = aws_cloudfront_distribution.distribution_app.hosted_zone_id
  }
}

resource "aws_route53_record" "www_app_cloudfront_domain" {
  depends_on = [aws_cloudfront_distribution.distribution_app]
  name       = "www.${var.dominio}"
  zone_id    = aws_route53_zone.this.id
  type       = "A"

  alias {
    evaluate_target_health = false
    name                   = aws_cloudfront_distribution.distribution_app.domain_name
    zone_id                = aws_cloudfront_distribution.distribution_app.hosted_zone_id
  }
}

output "distribution_app" {
  value = aws_cloudfront_distribution.distribution_app
}
# output "distruibution_id" {
#   value = aws_cloudfront_distribution.this.id
# }