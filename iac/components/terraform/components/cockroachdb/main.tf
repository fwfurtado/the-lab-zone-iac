module "this" {
  depends_on = [consul_acl_token.this]
  source     = "../../modules/lxc"

  for_each = { for server in var.cockroachdb.servers : server.id => server }

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

      entrypoint = "/cockroach/cockroach.sh start --insecure --http-addr=0.0.0.0:8080 --advertise-addr=${each.value.ip} --join=${local.join_addresses} --cache=512MiB"
    }
  )
}
