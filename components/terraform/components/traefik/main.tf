module "this" {
  depends_on = [consul_acl_token.traefik]
  source     = "../../modules/lxc"

  proxmox_node_name    = var.proxmox_node_name
  proxmox_host         = var.proxmox_host
  proxmox_ssh_username = var.proxmox_ssh_username
  proxmox_ssh_agent    = var.proxmox_ssh_agent

  defaults = var.defaults

  container = merge(var.container,
    {
      id          = var.traefik.id,
      hostname    = var.traefik.hostname,
      description = var.traefik.description,
      entrypoint  = "/entrypoint.sh --configFile=/etc/traefik/traefik.yaml",
      network = {
        ip_cidr = var.traefik.ip_cidr,
        dns = {
          servers = var.traefik.dns.servers,
        }
      }

      files = {
        "/etc/traefik/traefik.yaml"        = yamlencode(local.traefik.config),
        "/etc/traefik/dynamic_config.yaml" = yamlencode(local.traefik.dynamic_config),
      }

      environment_variables = {
        CF_DNS_API_TOKEN = var.cloudflare_api_key
      }
    }
  )
}
