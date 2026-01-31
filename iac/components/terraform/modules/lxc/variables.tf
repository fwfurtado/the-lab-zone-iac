variable "proxmox_node_name" {
  type = string
  description = "The name of the Proxmox node"
}

variable "proxmox_host" {
  type = string
  description = "The host of the Proxmox node"
}

variable "proxmox_ssh_username" {
  type = string
  description = "The username of the Proxmox SSH user"
}

variable "proxmox_ssh_agent" {
  type = bool
  description = "Whether to use the SSH agent"
}

variable "container" {
  type = object({
    id          = number
    hostname    = string
    description = string

    entrypoint = optional(string, null)

    image = object({
      repository = string
      storage_id = optional(string)
      registry   = optional(string)
      tag        = optional(string)
    })

    resources = object({
      cpu    = number
      memory = number
      disk = object({
        size       = number
        storage_id = optional(string)
      })
    })

    network = object({
      ip_cidr        = string
      interface_name = optional(string)
      bridge         = optional(string)
      gateway        = optional(string)
      dns = optional(object({
        servers = optional(list(string))
      }))
    })

    mount_points = optional(list(object({
      volume = string
      path   = string
      size   = string
    })), [])

    features = optional(object({
      nesting      = optional(bool)
      unprivileged = optional(bool)
    }))

    files                 = optional(map(string), {})
    environment_variables = optional(map(string), {})

  })
  description = "The container configuration"
}


variable "defaults" {
  type = object({
    image = optional(object({
      storage_id = optional(string, "local")
      registry   = optional(string, "docker.io")
      tag        = optional(string, "latest")
    }), {})
    network = optional(object({
      interface_name = optional(string, "eth0")
      bridge         = optional(string, "vmbr0")
      gateway        = optional(string, "192.168.40.1")
      dns_servers    = optional(list(string), [])
    }), {})
    disk = optional(object({
      storage_id = optional(string, "local-lvm")
    }), {})
    features = optional(object({
      nesting      = optional(bool, true)
      unprivileged = optional(bool, true)
    }), {})
    environment_variables = optional(map(string), {})
    mount_points = optional(list(object({
      volume = string
      path   = string
      size   = string
    })), [])
    files = optional(map(string), {})
  })
  default = {}
}
