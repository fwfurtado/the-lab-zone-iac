variable "proxmox_node_name" {
  type        = string
  description = "The name of the Proxmox node"
}

variable "group" {
  type = object({
    name        = string
    description = optional(string)
    tags        = optional(list(string), [])
    started     = optional(bool)
    on_boot     = optional(bool)
  })
  description = "The VM group configuration"
}

variable "vms" {
  type = list(object({
    name           = string
    id             = number
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
  description = "The VM definitions"
}

variable "operating_system_type" {
  type        = string
  description = "The Proxmox OS type for the VM"
  default     = "l26"
}

variable "cdrom" {
  type = object({
    enabled   = optional(bool, true)
    file_id   = optional(string)
    interface = optional(string, "ide2")
  })
  description = "Optional CDROM settings"
  default     = {}

  validation {
    condition     = coalesce(try(var.cdrom.enabled, null), true) == false || try(var.cdrom.file_id, null) != null
    error_message = "cdrom.file_id must be set when cdrom.enabled is true."
  }
}

variable "boot_order" {
  type        = list(string)
  description = "Boot device order"
  default     = ["scsi0"]
}

variable "agent_enabled" {
  type        = bool
  description = "Enable the Proxmox guest agent"
  default     = false
}

variable "stop_on_destroy" {
  type        = bool
  description = "Stop VM on destroy"
  default     = true
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
  description = "Default values for VMs"
  default     = {}
}
