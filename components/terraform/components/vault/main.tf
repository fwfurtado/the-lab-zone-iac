module "vault" {
  depends_on = [consul_acl_token.vault]
  source     = "../../modules/lxc"

  for_each = { for server in var.vault.servers : server.id => server }

  proxmox_node_name    = var.proxmox_node_name
  proxmox_host         = var.proxmox_host
  proxmox_ssh_username = var.proxmox_ssh_username
  proxmox_ssh_agent    = var.proxmox_ssh_agent

  defaults = var.defaults

  container = merge(var.container,
    {
      id          = each.value.id,
      hostname    = each.value.hostname,
      description = each.value.description,
      network = {
        ip_cidr = each.value.ip_cidr,
      },

      entrypoint = "docker-entrypoint.sh server"

      files = {
        "/vault/config/vault.json" = jsonencode(
          merge(local.config,
            {
              api_addr     = "http://${split("/", each.value.ip_cidr)[0]}:8200"
              cluster_addr = "http://${split("/", each.value.ip_cidr)[0]}:8201"
              storage = {
                "consul" = {
                  service      = "vault"
                  service_tags = "active,standby"
                  path         = "vault/"
                  address      = nonsensitive(data.tfe_outputs.consul.values.connections.leader.address)
                  token        = nonsensitive(data.consul_acl_token_secret_id.this.secret_id)
                }
              }
            }
          )
        )
      }
    }
  )
}
