locals {
  cluster = {
    name        = var.cluster.name
    description = coalesce(try(var.cluster.description, null), "Talos cluster ${var.cluster.name}")
    tags = sort(distinct(concat(
      try(var.cluster.tags, []),
      ["talos", format("cluster:%s", var.cluster.name)]
    )))
    started = coalesce(try(var.cluster.started, null), try(var.defaults.started, null), true)
    on_boot = coalesce(try(var.cluster.on_boot, null), try(var.defaults.on_boot, null), true)
  }

  nodes = {
    for node in var.nodes :
    node.name => {
      name    = "${var.cluster.name}-${node.name}"
      id      = node.id
      role    = node.role
      cpu     = node.cpu
      memory  = node.memory
      started = coalesce(try(node.started, null), local.cluster.started)
      on_boot = coalesce(try(node.on_boot, null), local.cluster.on_boot)
      disk = {
        size         = node.disk_size
        datastore_id = coalesce(try(node.datastore_id, null), try(var.defaults.disk.storage_id, null), "local-lvm")
      }
      network = {
        bridge  = coalesce(try(node.network_bridge, null), try(var.defaults.network.bridge, null), "vmbr0")
        ip_cidr = try(node.ip_cidr, null)
      }
      tags = sort(distinct(concat(
        local.cluster.tags,
        [node.role],
        try(node.tags, [])
      )))
    }
  }
}
