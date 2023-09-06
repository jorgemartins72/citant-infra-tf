resource "aws_s3_bucket" "bucket_codepipeline_api" {
  bucket        = "${var.projeto}-pipeline-artifacts"
  force_destroy = true
}

resource "aws_s3_bucket_ownership_controls" "codepipeline_api_bucket_ownership_controls" {
  bucket = aws_s3_bucket.bucket_codepipeline_api.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "codepipeline_api_bucket_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.codepipeline_api_bucket_ownership_controls]
  bucket     = aws_s3_bucket.bucket_codepipeline_api.id
  acl        = "private"
}
