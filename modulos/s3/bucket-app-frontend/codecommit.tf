resource "aws_codecommit_repository" "codecommit_app" {
  repository_name = "${var.projeto}-app"
}

output "codecommit_app_url" {
  value = aws_codecommit_repository.codecommit_app.clone_url_http
}
# output "repositorio_arn" {
#   value = aws_codecommit_repository.codecommit_api.arn
# }
# output "repositorio_name" {
#   value = aws_codecommit_repository.codecommit_api.repository_name
# }

