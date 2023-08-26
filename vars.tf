variable "projeto" {}
variable "tagname" {}
variable "dominio_app_frontend" {}
variable "dominio_website" {}
variable "total_subnets" {}
variable "docker_username" {
  description = "Definir TF_VAR_docker_username no ~/.zshrc"
}
variable "docker_userpass" {
  description = "Definir TF_VAR_docker_userpass no ~/.zshrc"
}
