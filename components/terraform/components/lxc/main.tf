resource "proxmox_virtual_environment_container" "this" {
  depends_on = [proxmox_virtual_environment_file.template]

  description = local.container.description
  node_name   = local.proxmox.node.name
  vm_id       = local.container.id

  template = false
  started  = local.container.started

  cpu {
    cores = local.container.resources.cpu
  }

  memory {
    dedicated = local.container.resources.memory
  }

  initialization {
    hostname = local.container.hostname

    dynamic "dns" {
      for_each = length(local.container.network.dns.servers) > 0 ? [1] : []
      content {
        servers = local.container.network.dns.servers
      }
    }

    ip_config {
      ipv4 {
        address = local.container.network.ip_cidr
        gateway = local.container.network.gateway
      }
    }
  }

  operating_system {
    template_file_id = proxmox_virtual_environment_file.template.id
    type             = local.container.image.type
  }

  network_interface {
    name   = local.container.network.interface_name
    bridge = local.container.network.bridge
  }

  disk {
    datastore_id = local.container.resources.disk.storage_id
    size         = local.container.resources.disk.size
  }

  dynamic "mount_point" {
    for_each = local.container.mount_points
    content {
      volume = mount_point.value.volume
      path   = mount_point.value.path
      size   = mount_point.value.size
      backup = mount_point.value.backup
    }
  }

  features {
    nesting = local.container.features.nesting
  }

  unprivileged = local.container.features.unprivileged

  tags = local.container.tags

  lifecycle {
    ignore_changes = [
      started,
      console,
      network_interface[0].mac_address,
    ]
  }
}

resource "null_resource" "extra_pve_conf" {
  count = length(var.extra_pve_conf_lines) > 0 ? 1 : 0

  depends_on = [proxmox_virtual_environment_container.this]

  connection {
    type  = "ssh"
    user  = local.proxmox.ssh.username
    host  = local.proxmox.ssh.host
    agent = local.proxmox.ssh.agent
  }

  provisioner "remote-exec" {
    inline = concat(
      [
        for line in var.extra_pve_conf_lines :
        "echo '${line}' | sudo tee -a /etc/pve/lxc/${local.container.id}.conf"
      ],
      var.extra_reboot_after_pve_changes ? [
        "sudo pct reboot ${local.container.id} --timeout 60"
      ] : []
    )
  }
}
