# output "docker" {
#   value = module.docker
# }

# output "compose_file" {
#   value = local.compose_config
# }


output "truenas_app" {
  value = module.truenas_app.all
  sensitive = true
}
