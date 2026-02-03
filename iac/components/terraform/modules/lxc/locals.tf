locals {

  proxmox = {
    node = {
      name = var.proxmox_node_name
    }
    ssh = {
      username = var.proxmox_ssh_username
      host     = var.proxmox_host
      agent    = var.proxmox_ssh_agent
    }
  }

  # Merge dos valores do container com os defaults
  container = {
    id            = var.container.id
    hostname      = var.container.hostname
    description   = var.container.description
    entrypoint    = var.container.entrypoint
    started       = var.container.started
    should_reboot = var.container.should_reboot

    image = {
      repository = var.container.image.repository
      storage_id = coalesce(var.container.image.storage_id, var.defaults.image.storage_id, "local")
      registry   = coalesce(var.container.image.registry, var.defaults.image.registry, "docker.io")
      tag        = coalesce(var.container.image.tag, var.defaults.image.tag, "latest")
      type       = coalesce(var.container.image.type, var.defaults.image.type, "alpine")
    }

    resources = {
      cpu    = var.container.resources.cpu
      memory = var.container.resources.memory
      disk = {
        size       = var.container.resources.disk.size
        storage_id = coalesce(var.container.resources.disk.storage_id, var.defaults.disk.storage_id, "local-lvm")
      }
    }

    network = {
      ip_cidr        = var.container.network.ip_cidr
      interface_name = coalesce(var.container.network.interface_name, var.defaults.network.interface_name, "eth0")
      bridge         = coalesce(var.container.network.bridge, var.defaults.network.bridge, "vmbr0")
      gateway        = coalesce(var.container.network.gateway, var.defaults.network.gateway, "192.168.40.1")
      dns = {
        servers = coalesce(try(var.container.network.dns.servers, null), var.defaults.network.dns_servers, [])
      }
    }

    features = {
      nesting      = coalesce(try(var.container.features.nesting, null), var.defaults.features.nesting, true)
      unprivileged = coalesce(try(var.container.features.unprivileged, null), var.defaults.features.unprivileged, true)
    }

    environment_variables = coalesce(var.container.environment_variables, var.defaults.environment_variables, {})
    mount_points          = coalesce(var.container.mount_points, var.defaults.mount_points, [])
    files                 = coalesce(var.container.files, var.defaults.files, {})
  }
}
