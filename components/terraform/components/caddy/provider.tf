provider "docker" {
  host = var.provider_config.docker_host
  ssh_opts = var.provider_config.ssh_opts

 dynamic "registry_auth" {
  for_each = var.provider_config.registry_auth != null ? [1] : []
  content {
    address = var.provider_config.registry_auth.address
    username = var.provider_config.registry_auth.username
    password = var.provider_config.registry_auth.password
  }
 }
}
