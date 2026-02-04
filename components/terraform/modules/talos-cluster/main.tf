resource "proxmox_virtual_environment_vm" "nodes" {
  for_each = local.nodes

  name        = each.value.name
  description = "Talos ${local.cluster.name} ${each.value.role}"
  tags        = each.value.tags

  node_name = var.proxmox_node_name
  vm_id     = each.value.id

  agent {
    enabled = false
  }
  stop_on_destroy = true

  cpu {
    cores = each.value.cpu
  }

  memory {
    dedicated = each.value.memory
  }

  disk {
    datastore_id = each.value.disk.datastore_id
    interface    = "scsi0"
    size         = each.value.disk.size
  }

  network_device {
    bridge = each.value.network.bridge
  }

  operating_system {
    type = var.operating_system_type
  }

  cdrom {
    enabled   = true
    file_id   = var.talos_iso_file_id
    interface = "ide2"
  }

  boot_order = ["scsi0", "ide2"]

  started = each.value.started
  on_boot = each.value.on_boot

  lifecycle {
    ignore_changes = [
      network_device[0].mac_address,
    ]
  }
}
