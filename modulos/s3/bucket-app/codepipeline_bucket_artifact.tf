resource "aws_s3_bucket" "bucket_codepipeline_app" {
  bucket        = "${var.projeto}-app-pipeline-artifacts"
  force_destroy = true
}

resource "aws_s3_bucket_ownership_controls" "codepipeline_website_bucket_ownership_controls" {
  bucket = aws_s3_bucket.bucket_codepipeline_app.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "codepipeline_app_bucket_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.codepipeline_website_bucket_ownership_controls]
  bucket     = aws_s3_bucket.bucket_codepipeline_app.id
  acl        = "private"
}
