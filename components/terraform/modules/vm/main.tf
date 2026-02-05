resource "proxmox_virtual_environment_vm" "nodes" {
  for_each = local.vms

  name        = each.value.name
  description = local.group.description
  tags        = each.value.tags

  node_name = var.proxmox_node_name
  vm_id     = each.value.id

  agent {
    enabled = var.agent_enabled
  }
  stop_on_destroy = var.stop_on_destroy

  cpu {
    cores = each.value.cpu
    type = var.cpu_type
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

  dynamic "cdrom" {
    for_each = local.cdrom_enabled ? [local.cdrom] : []
    content {
      enabled   = true
      file_id   = cdrom.value.file_id
      interface = cdrom.value.interface
    }
  }

  boot_order = var.boot_order

  started = each.value.started
  on_boot = each.value.on_boot

  lifecycle {
    ignore_changes = [
      network_device[0].mac_address,
      cdrom, # avoid 403 VM.Config.CDROM on update; CDROM only needed for initial boot
    ]
  }
}
