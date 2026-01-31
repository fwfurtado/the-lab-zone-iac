resource "proxmox_virtual_environment_container" "this" {
  depends_on = [module.oci-image-download]

  description = local.container.description
  node_name   = local.proxmox.node.name
  vm_id       = local.container.id

  template = false

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
    template_file_id = module.oci-image-download.id
    type             = "alpine"
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
    }
  }


  features {
    nesting = local.container.features.nesting
  }

  unprivileged = local.container.features.unprivileged
}


resource "null_resource" "reboot" {
  depends_on = [proxmox_virtual_environment_container.this, null_resource.envs, null_resource.files, null_resource.override_entrypoint]

  triggers = {
    container_id = proxmox_virtual_environment_container.this.id
  }

  connection {
    type  = "ssh"
    user  = local.proxmox.ssh.username
    host  = local.proxmox.ssh.host
    agent = local.proxmox.ssh.agent
  }

  provisioner "remote-exec" {
    inline = [
      "sudo pct reboot ${local.container.id} --timeout 60",
    ]
  }
}