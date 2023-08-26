resource "aws_codecommit_repository" "this" {
  repository_name = "${var.projeto}-api"
}

output "repositorio_url" {
  value = aws_codecommit_repository.this.clone_url_http
}
output "repositorio_arn" {
  value = aws_codecommit_repository.this.arn
}

