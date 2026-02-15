provider "docker" {
  host = var.provider.docker_host
  ssh_opts = var.provider.ssh_opts

 dynamic "registry_auth" {
  for_each = var.provider.registry_auth != null ? [1] : []
  content {
    address = var.provider.registry_auth.address
    username = var.provider.registry_auth.username
    password = var.provider.registry_auth.password
  }
 }
}
