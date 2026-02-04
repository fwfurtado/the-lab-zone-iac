module "cluster" {
  depends_on = [consul_acl_token.this]
  source     = "../../modules/lxc"

  for_each = local.servers

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

      entrypoint = "/garage/garage server"
    }
  )
}


module "ui" {
  depends_on = [consul_acl_token.this]
  source     = "../../modules/lxc"

  for_each = local.ui_servers

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

      entrypoint = "/garage/garage ui"
    }
  )
}

resource "null_resource" "initialize" {
  depends_on = [module.this]

  connection {
    type  = "ssh"
    user  = var.proxmox_ssh_username
    host  = var.proxmox_host
    agent = var.proxmox_ssh_agent
  }

  provisioner "remote-exec" {
    inline = [
      "sleep 10",
    ]
  }
}