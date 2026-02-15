module "docker" {
  source = "../../modules/docker"

  provider = {
    docker_host = var.docker.provider.docker_host
    ssh_opts = var.docker.provider.ssh_opts
    registry_auth = var.docker.provider.registry_auth
  }

  image = {
    registry = var.docker.image.registry
    repository = var.docker.image.repository
    tag = var.docker.image.tag
  }

  context = var.docker.context
  dockerfile = var.docker.dockerfile
  platform = var.docker.platform
  build_args = var.docker.build_args
}
