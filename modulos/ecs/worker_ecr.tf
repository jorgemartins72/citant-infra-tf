resource "aws_ecr_repository" "ecr_worker" {
  name         = "${var.projeto}-worker"
  force_delete = true
}
output "ecr_worker_repository_url" {
  value = aws_ecr_repository.ecr_worker.repository_url
}