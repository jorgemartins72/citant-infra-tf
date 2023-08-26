resource "aws_ecr_repository" "this" {
  name         = "${var.projeto}-api"
  force_delete = true
}
output "repositorio_url" {
  value = aws_ecr_repository.this.repository_url
}
