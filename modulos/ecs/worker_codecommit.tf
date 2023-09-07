resource "aws_codecommit_repository" "codecommit_worker" {
  repository_name = "${var.projeto}-worker"
}

output "codecommit_worker_url" {
  value = aws_codecommit_repository.codecommit_worker.clone_url_http
}
# output "repositorio_arn" {
#   value = aws_codecommit_repository.codecommit_api.arn
# }
# output "repositorio_name" {
#   value = aws_codecommit_repository.codecommit_api.repository_name
# }

