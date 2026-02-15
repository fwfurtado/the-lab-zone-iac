output "docker" {
  value = module.docker
}

output "compose_file" {
  value = local.compose_config
}
