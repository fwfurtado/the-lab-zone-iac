locals {
  group = {
    name        = var.group.name
    description = coalesce(try(var.group.description, null), "VM group ${var.group.name}")
    tags        = sort(distinct(try(var.group.tags, [])))
    started     = coalesce(try(var.group.started, null), try(var.defaults.started, null), true)
    on_boot     = coalesce(try(var.group.on_boot, null), try(var.defaults.on_boot, null), true)
  }

  vms = {
    for vm in var.vms :
    vm.name => {
      name    = "${var.group.name}-${vm.name}"
      id      = vm.id
      cpu     = vm.cpu
      memory  = vm.memory
      started = coalesce(try(vm.started, null), local.group.started)
      on_boot = coalesce(try(vm.on_boot, null), local.group.on_boot)
      disk = {
        size         = vm.disk_size
        datastore_id = coalesce(try(vm.datastore_id, null), try(var.defaults.disk.storage_id, null), "local-lvm")
      }
      network = {
        bridge  = coalesce(try(vm.network_bridge, null), try(var.defaults.network.bridge, null), "vmbr0")
        ip_cidr = try(vm.ip_cidr, null)
        gateway = try(vm.gateway, null)
      }
      tags = sort(distinct(concat(
        local.group.tags,
        try(vm.tags, [])
      )))
    }
  }

  cdrom_enabled = coalesce(try(var.cdrom.enabled, null), true)
  cdrom = {
    file_id   = try(var.cdrom.file_id, null)
    interface = coalesce(try(var.cdrom.interface, null), "ide2")
  }
}
