# module "docker" {
#   source = "../../modules/docker"

#   provider_config = {
#     docker_host = var.docker.provider.docker_host
#     ssh_opts = var.docker.provider.ssh_opts
#     registry_auth = var.docker.provider.registry_auth
#   }

#   image = {
#     registry = var.docker.image.registry
#     repository = var.docker.image.repository
#     tag = var.docker.image.tag
#   }

#   context = path.module
#   platform = "linux/amd64"
# }


module "truenas_app" {
  # depends_on = [ module.docker ]

  source = "../../modules/truenas-app"

  name = "caddy"
  compose = ""
  datasets = [
    {
      path = "caddy/config"
    },
    {
      path = "caddy/data"
    },
    {
      path = "caddy/logs"
    }
  ]
  files = {
    "caddy/config/Caddyfile" = {
      content = file("${path.module}/Caddyfile")
    }
  }
}
