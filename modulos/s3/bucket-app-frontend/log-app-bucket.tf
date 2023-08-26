# resource "aws_s3_bucket" "log-app" {
#   bucket        = "${var.dominio}--logs"
#   force_destroy = true
#   tags = {
#     Name = "Log do app ${var.dominio}"
#   }
# }

# resource "aws_s3_bucket_ownership_controls" "log-app-ownership_controls" {
#   bucket = aws_s3_bucket.log-app.id
#   rule {
#     object_ownership = "BucketOwnerPreferred"
#   }
# }

# resource "aws_s3_bucket_acl" "log-app-acl" {
#   depends_on = [aws_s3_bucket_ownership_controls.log-app-ownership_controls]
#   bucket     = aws_s3_bucket.log-app.id
#   acl        = "private"
# }