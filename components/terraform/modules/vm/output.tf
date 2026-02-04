output "group" {
  value = {
    name        = local.group.name
    description = local.group.description
    tags        = local.group.tags
    vms = {
      for vm_key, vm in proxmox_virtual_environment_vm.nodes :
      vm_key => {
        id            = vm.id
        vm_id         = vm.vm_id
        name          = vm.name
        ip_cidr       = local.vms[vm_key].network.ip_cidr
        mac_addresses = vm.mac_addresses
        tags          = local.vms[vm_key].tags
      }
    }
  }
}
