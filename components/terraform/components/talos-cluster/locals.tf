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

  vms = [
    for node in var.nodes : {
      name           = node.name
      id             = node.id
      role           = node.role
      cpu            = node.cpu
      memory         = node.memory
      disk_size      = node.disk_size
      datastore_id   = try(node.datastore_id, null)
      network_bridge = try(node.network_bridge, null)
      ip_cidr        = node.ip_cidr
      started        = try(node.started, null)
      on_boot        = try(node.on_boot, null)
      tags = sort(distinct(concat(
        local.cluster.tags,
        [node.role],
        try(node.tags, [])
      )))
      ip = split("/", node.ip_cidr)[0]
    }
  ]

  nodes_by_name = {
    for node in local.vms :
    node.name => node
  }

  controlplane_ips = [
    for node in local.vms :
    node.ip if node.role == "controlplane"
  ]

  worker_ips = [
    for node in local.vms :
    node.ip if node.role == "worker"
  ]

  cluster_endpoint = coalesce(var.cluster_endpoint, format("https://%s:6443", local.controlplane_ips[0]))
  install_disk_patch = yamlencode({
    machine = {
      install = {
        disk = var.talos_install_disk
      }
    }
  })

  requested_extensions = distinct(var.talos_image_extensions)
  resolved_extensions  = distinct(data.talos_image_factory_extensions_versions.this.extensions_info.*.name)
  missing_extensions   = setsubtract(toset(local.requested_extensions), toset(local.resolved_extensions))
}
