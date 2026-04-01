provider "proxmox" {
  ssh {
    node {
      name    = var.proxmox_node_name
      address = var.proxmox_ssh_host
    }

    username = var.proxmox_ssh_username
    agent    = true
  }
}
