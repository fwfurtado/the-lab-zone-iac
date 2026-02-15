provider "docker" {
  host = var.docker.provider.docker_host
  ssh_opts = var.docker.provider.ssh_opts

  registry_auth {
    address = var.docker.provider.registry_auth.address
    username = var.docker.provider.registry_auth.username
    password = var.docker.provider.registry_auth.password
  }
}


provider "truenas" {
  host = var.truenas.host
  auth_method = "ssh"

  ssh {
    user = var.truenas.username
    host_key_fingerprint = var.truenas.fingerprint
    private_key = var.truenas.private_key
  }
}
