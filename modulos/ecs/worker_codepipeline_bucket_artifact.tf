resource "aws_s3_bucket" "bucket_codepipeline_worker" {
  bucket        = "${var.projeto}-worker-pipeline-artifacts"
  force_destroy = true
}

resource "aws_s3_bucket_ownership_controls" "codepipeline_worker_bucket_ownership_controls" {
  bucket = aws_s3_bucket.bucket_codepipeline_worker.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "codepipeline_worker_bucket_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.codepipeline_worker_bucket_ownership_controls]
  bucket     = aws_s3_bucket.bucket_codepipeline_worker.id
  acl        = "private"
}
