resource "aws_ecr_repository" "ecr_api" {
  name         = "${var.projeto}-api"
  force_delete = true
}
output "repositorio_url" {
  value = aws_ecr_repository.ecr_api.repository_url
}
