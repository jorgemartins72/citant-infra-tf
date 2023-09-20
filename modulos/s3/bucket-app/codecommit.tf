resource "aws_codecommit_repository" "codecommit_app" {
  repository_name = "${var.projeto}-app"
}

output "codecommit_app_url" {
  value = aws_codecommit_repository.codecommit_app.clone_url_http
}
output "codecommit_app_arn" {
  value = aws_codecommit_repository.codecommit_app.arn
}
output "codecommit_app_name" {
  value = aws_codecommit_repository.codecommit_app.repository_name
}

