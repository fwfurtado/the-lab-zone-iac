output "cluster" {
  value = {
    name        = local.cluster.name
    description = local.cluster.description
    nodes = {
      for node_key, node in proxmox_virtual_environment_vm.nodes :
      node_key => {
        id            = node.id
        vm_id         = node.vm_id
        name          = node.name
        role          = local.nodes[node_key].role
        ip_cidr       = local.nodes[node_key].network.ip_cidr
        mac_addresses = node.mac_addresses
      }
    }
  }
}
