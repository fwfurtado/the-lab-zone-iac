variable "proxmox_node_name" {
  type        = string
  description = "The name of the Proxmox node"
}

variable "cluster" {
  type = object({
    name        = string
    description = optional(string)
    tags        = optional(list(string), [])
    started     = optional(bool)
    on_boot     = optional(bool)
  })
  description = "The Talos cluster configuration"
}

variable "nodes" {
  type = list(object({
    name           = string
    id             = number
    role           = string
    cpu            = number
    memory         = number
    disk_size      = number
    datastore_id   = optional(string)
    network_bridge = optional(string)
    ip_cidr        = optional(string)
    started        = optional(bool)
    on_boot        = optional(bool)
    tags           = optional(list(string), [])
  }))
  description = "The Talos nodes configuration"
}

variable "talos_iso_file_id" {
  type        = string
  description = "Proxmox file ID for the Talos ISO (e.g. local:iso/talos-amd64.iso)"
}

variable "operating_system_type" {
  type        = string
  description = "The Proxmox OS type for the VM"
  default     = "l26"
}

variable "defaults" {
  type = object({
    disk = optional(object({
      storage_id = optional(string, "local-lvm")
    }), {})
    network = optional(object({
      bridge = optional(string, "vmbr0")
    }), {})
    started = optional(bool, true)
    on_boot = optional(bool, true)
  })
  description = "Default values for Talos VMs"
  default     = {}
}
