variable "stage" {
  type        = string
  description = "The stage of the stack"
}

variable "proxmox_node_name" {
  type        = string
  description = "The name of the Proxmox node"
}

variable "proxmox_host" {
  type        = string
  description = "The host of the Proxmox node"
}

variable "proxmox_ssh_username" {
  type        = string
  description = "The username of the Proxmox SSH user"
}

variable "proxmox_ssh_agent" {
  type        = bool
  description = "Whether to use the SSH agent"
}

variable "template_file" {
  type        = string
  description = "Path to a local .tar.gz LXC template built by Packer"
}

variable "container" {
  type = object({
    id          = number
    hostname    = string
    description = string
    started     = optional(bool, true)

    image = object({
      storage_id = optional(string)
      type       = optional(string)
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
      backup = optional(bool)
    })), [])

    features = optional(object({
      nesting      = optional(bool)
      unprivileged = optional(bool)
    }))

    tags = optional(list(string), [])
  })
  description = "The container configuration"
}

variable "defaults" {
  type = object({
    image = optional(object({
      storage_id = optional(string, "local")
      type       = optional(string, "debian")
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
    mount_points = optional(list(object({
      volume = string
      path   = string
      size   = string
      backup = optional(bool, false)
    })), [])
  })
  default = {}
}

variable "extra_pve_conf_lines" {
  type        = list(string)
  description = "Additional lines to append to /etc/pve/lxc/<id>.conf on the Proxmox host"
  default     = []
}

variable "extra_reboot_after_pve_changes" {
  type        = bool
  description = "Whether to force a pct reboot after applying extra_pve_conf_lines"
  default     = false
}
