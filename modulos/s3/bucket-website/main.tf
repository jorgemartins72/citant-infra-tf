# resource "aws_s3_bucket_app_configuration" "web" {
#   bucket = aws_s3_bucket.this.id
#   index_document {
#     suffix = "index.html"
#   }

#   error_document {
#     key = "error.html"
#   }

# }

# resource "aws_s3_bucket_policy" "this" {
#   bucket = aws_s3_bucket.this.id
#   policy = <<EOF
# {
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#             "Sid": "PublicReadGetObject", 
#             "Effect": "Allow",
#             "Principal": {
#               "AWS": "arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity ${aws_cloudfront_origin_access_identity.this.id}"
#             },
#             "Action": "s3:GetObject",
#             "Resource": "arn:aws:s3:::${var.dominio}/*"
#         }
#     ]
# }
# EOF
# }

# resource "aws_s3_bucket" "this" {
#   bucket        = var.dominio
#   force_destroy = true
#   #   depends_on = [ aws_s3_bucket_policy.this ]
#   tags = {
#     Name = "Site ${var.dominio}"
#   }
# }


# resource "aws_s3_bucket_ownership_controls" "this" {
#   bucket = aws_s3_bucket.this.id
#   rule {
#     object_ownership = "BucketOwnerPreferred"
#   }
# }

# resource "aws_s3_bucket_public_access_block" "this" {
#   bucket = aws_s3_bucket.this.id

#   block_public_acls       = false
#   block_public_policy     = false
#   ignore_public_acls      = false
#   restrict_public_buckets = false
# }

# resource "aws_s3_bucket_acl" "this" {
#   depends_on = [
#     aws_s3_bucket_ownership_controls.this,
#     aws_s3_bucket_public_access_block.this,
#   ]

#   bucket = aws_s3_bucket.this.id
#   acl    = "public-read"
# }

# resource "aws_s3_object" "object" {
#   bucket        = var.dominio
#   key           = "index.html"
#   source        = "${path.module}/index.html"
#   content_type  = "text/html"
#   force_destroy = true
#   depends_on    = [aws_s3_bucket.this]
# }