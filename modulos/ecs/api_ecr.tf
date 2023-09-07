resource "aws_ecr_repository" "ecr_api" {
  name         = "${var.projeto}-api"
  force_delete = true
}
output "ecr_api_repository_url" {
  value = aws_ecr_repository.ecr_api.repository_url
}
