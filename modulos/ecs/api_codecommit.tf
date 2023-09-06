resource "aws_codecommit_repository" "codecommit_api" {
  repository_name = "${var.projeto}-api"
}

output "codecommit_api_url" {
  value = aws_codecommit_repository.codecommit_api.clone_url_http
}
# output "repositorio_arn" {
#   value = aws_codecommit_repository.codecommit_api.arn
# }
# output "repositorio_name" {
#   value = aws_codecommit_repository.codecommit_api.repository_name
# }

