locals {
  cluster = {
    name        = var.cluster.name
    description = coalesce(try(var.cluster.description, null), "Talos cluster ${var.cluster.name}")
    tags = sort(distinct(concat(
      try(var.cluster.tags, []),
      ["talos", format("cluster-%s", var.cluster.name)]
    )))
    started = coalesce(try(var.cluster.started, null), true)
    on_boot = coalesce(try(var.cluster.on_boot, null), true)
  }

  vms = [
    for node in var.nodes : {
      name            = node.name
      id              = node.id
      role            = node.role
      cpu             = node.cpu
      memory          = node.memory
      disk_size       = node.disk_size
      datastore_id    = try(node.datastore_id, null)
      network_bridge  = try(node.network_bridge, null)
      ip_cidr         = node.ip_cidr
      gateway         = var.node_network_gateway
      static_ip_cidr  = coalesce(try(node.static_ip_cidr, null), node.ip_cidr)
      started         = try(node.started, null)
      on_boot         = try(node.on_boot, null)
      tags = sort(distinct(concat(
        local.cluster.tags,
        [node.role],
        try(node.tags, [])
      )))
      ip = split("/", node.ip_cidr)[0]
    }
  ]

  # Per-node static network patch so Talos uses the desired IP (e.g. after first apply over DHCP IP).
  network_patches = var.node_network_gateway != "" ? {
    for node in local.vms : node.name => yamlencode({
      machine = {
        network = {
          interfaces = [
            {
              deviceSelector = {
                physical = true
              }
              addresses = [node.static_ip_cidr]
              routes = [
                { network = "0.0.0.0/0", gateway = var.node_network_gateway }
              ]
              dhcp = false
            }
          ]
        }
      }
    })
  } : {}

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
  resolved_extensions  = length(local.requested_extensions) == 0 ? [] : try(distinct(data.talos_image_factory_extensions_versions.this.extensions_info[*].name), [])
  missing_extensions   = setsubtract(toset(local.requested_extensions), toset(local.resolved_extensions))

   registry_config_patch = var.image_registry_password != "" ? yamlencode({
    machine = {
      registries = {
        mirrors = {
          "docker.io" = {
            endpoints    = ["http://10.40.1.30:5000/v2/docker"]
            overridePath = true
          }
          "ghcr.io" = {
            endpoints    = ["http://10.40.1.30:5000/v2/ghcr"]
            overridePath = true
          }
          "registry.k8s.io" = {
            endpoints    = ["http://10.40.1.30:5000/v2/k8s"]
            overridePath = true
          }
          "quay.io" = {
            endpoints    = ["http://10.40.1.30:5000/v2/quay"]
            overridePath = true
          }
          "docker.gitea.com" = {
            endpoints    = ["http://10.40.1.30:5000/v2/gitea"]
            overridePath = true
          }
          "ecr-public.aws.com" = {
            endpoints    = ["http://10.40.1.30:5000/v2/ecr"]
            overridePath = true
          }
        }
        config = {
          "10.40.1.30:5000" = {
            auth = {
              username = var.image_registry_username
              password = var.image_registry_password
            }
          }
        }
      }
    }
  }) : ""
}
