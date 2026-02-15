locals {
  compose_config = templatefile("${path.module}/compose.tpl.yaml", {
    image              = module.docker.image.name
    cloudflare_api_key = var.cloudflare_api_key
    garage_endpoint    = var.garage_endpoint
    garage_bucket      = var.garage_bucket
    garage_access_key  = var.garage_access_key
    garage_secret_key  = var.garage_secret_key
    gitea_ssh_backend  = var.gitea_ssh_backend
    config_path        = "/mnt/pool/docker/caddy/config"
    data_path          = "/mnt/pool/docker/caddy/data"
    logs_path          = "/mnt/pool/docker/caddy/logs"
  })
}


variable "cloudflare_api_key" {
  type = string
  description = "The Cloudflare API key"
}

variable "garage_endpoint" {
  type = string
  description = "The Garage endpoint"
}

variable "garage_bucket" {
  type = string
  description = "The Garage bucket"
}

variable "garage_access_key" {
  type = string
  description = "The Garage access key"
}

variable "garage_secret_key" {
  type = string
  description = "The Garage secret key"
}

variable "gitea_ssh_backend" {
  type = string
  description = "The Gitea SSH backend"
}
