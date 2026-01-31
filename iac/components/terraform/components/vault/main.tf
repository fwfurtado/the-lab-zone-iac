module "consul-cluster" {
  source   = "../../modules/lxc"

  for_each = { for server in var.consul.servers : server.id => server }

  proxmox_node_name    = var.proxmox_node_name
  proxmox_host         = var.proxmox_host
  proxmox_ssh_username = var.proxmox_ssh_username
  proxmox_ssh_agent    = var.proxmox_ssh_agent

  defaults = var.defaults

  container = merge(var.container_server, {
    id       = each.value.id,
    hostname = each.value.hostname,
    description = each.value.description,
    network = {
      ip_cidr = each.value.ip_cidr,
    },

    entrypoint = "docker-entrypoint.sh agent -config-file=/consul/config/consul.json"

    files = {
      "/consul/config/consul.json" = jsonencode(merge(local.server_config, { node_name = each.value.hostname }))
    }
  })
}


module "consul-esm" {
  source     = "../../modules/lxc"

  depends_on = [module.consul-cluster]

  for_each   = { for esm in var.consul.esm : esm.id => esm }

  proxmox_node_name    = var.proxmox_node_name
  proxmox_host         = var.proxmox_host
  proxmox_ssh_username = var.proxmox_ssh_username
  proxmox_ssh_agent    = var.proxmox_ssh_agent

  defaults = var.defaults

  container = merge(var.container_esm, {
    id       = each.value.id,
    hostname = each.value.hostname,
    description = each.value.description,
    network = {
      ip_cidr = each.value.ip_cidr,
    },

    entrypoint = "/bin/consul-esm -config-file=/consul/config/ems.json"

    files = {
      "/consul/config/ems.json" = jsonencode(merge(local.ems_config, { node_name = each.value.hostname }))
    }
  })
}


resource "consul_node" "consul-esm-registration" {
  depends_on = [module.consul-esm]

  for_each = { for esm in var.consul.esm : esm.id => esm }

  name    = each.value.hostname
  address = split("/", each.value.ip_cidr)[0]
}