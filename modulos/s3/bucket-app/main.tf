resource "aws_s3_bucket" "bucket_app" {
  bucket        = var.dominio
  force_destroy = true
  #   depends_on    = [aws_s3_bucket_policy.policy_website]
  tags = {
    Name = "Site ${var.dominio}"
  }
}

resource "aws_s3_bucket_ownership_controls" "ownership_controls_app" {
  bucket = aws_s3_bucket.bucket_app.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "bucket_acl_app" {
  depends_on = [
    aws_s3_bucket_ownership_controls.ownership_controls_app,
    aws_s3_bucket_public_access_block.public_access_block_app,
  ]

  bucket = aws_s3_bucket.bucket_app.id
  acl    = "public-read"
}

resource "aws_s3_bucket_public_access_block" "public_access_block_app" {
  bucket = aws_s3_bucket.bucket_app.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_website_configuration" "website_configuration_app" {
  bucket = aws_s3_bucket.bucket_app.id
  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }

}

resource "aws_s3_bucket_cors_configuration" "cors_configuration_app" {
  bucket = aws_s3_bucket.bucket_app.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "HEAD", "PUT", "POST"]
    allowed_origins = ["*"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }

  cors_rule {
    allowed_methods = ["GET"]
    allowed_origins = ["*"]
  }
}

resource "aws_s3_object" "object_app" {
  bucket        = var.dominio
  key           = "index.html"
  source        = "${path.module}/index.html"
  content_type  = "text/html"
  force_destroy = true
  depends_on    = [aws_s3_bucket.bucket_app]
}

output "bucket_app" {
  value = aws_s3_bucket.bucket_app
}

resource "aws_s3_bucket_policy" "policy_app" {
  bucket = aws_s3_bucket.bucket_app.id
  depends_on = [
    aws_s3_bucket.bucket_app,
    aws_s3_bucket_acl.bucket_acl_app,
    aws_s3_bucket_public_access_block.public_access_block_app
  ]
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject", 
            "Effect": "Allow",
            "Principal": {
              "AWS": "arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity ${aws_cloudfront_origin_access_identity.origin_access_identity_app.id}"
            },
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::${var.dominio}/*"
        }
    ]
}
POLICY
}

# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Action": "s3:*",
#       "Effect": "Allow",
#       "Resource": [
#         "${aws_s3_bucket.bucket_app.arn}",
#         "${aws_s3_bucket.bucket_app.arn}/*"
#       ],
#       "Principal": "*"
#     }
#   ]
# }