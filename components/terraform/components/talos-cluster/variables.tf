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
    ip_cidr        = string
    started        = optional(bool)
    on_boot        = optional(bool)
    tags           = optional(list(string), [])
  }))
  description = "The Talos nodes configuration"

  validation {
    condition     = length([for node in var.nodes : node if node.role == "controlplane"]) > 0
    error_message = "At least one controlplane node is required."
  }
}

variable "operating_system_type" {
  type        = string
  description = "The Proxmox OS type for the VM"
  default     = "l26"
}

variable "talos_config_patches" {
  type        = list(string)
  description = "Talos config patches applied to all nodes"
  default     = []
}

variable "controlplane_config_patches" {
  type        = list(string)
  description = "Talos config patches for controlplane nodes"
  default     = []
}

variable "worker_config_patches" {
  type        = list(string)
  description = "Talos config patches for worker nodes"
  default     = []
}

variable "talos_version" {
  type        = string
  description = "Talos version for generated machine configuration"
}

variable "talos_image_extensions" {
  type        = list(string)
  description = "Talos Image Factory official extensions to include"
  default     = []

  validation {
    condition     = alltrue([for name in var.talos_image_extensions : length(trimspace(name)) > 0])
    error_message = "talos_image_extensions must not contain empty values."
  }
}

variable "talos_image_platform" {
  type        = string
  description = "Talos Image Factory platform"
  default     = "metal"
}

variable "talos_image_architecture" {
  type        = string
  description = "Talos Image Factory architecture"
  default     = "amd64"
}

variable "talos_image_sbc" {
  type        = string
  description = "Talos Image Factory SBC target (optional)"
  default     = null
}

variable "talos_image_datastore_id" {
  type        = string
  description = "Proxmox datastore for Talos image download"
  default     = "local"
}

variable "talos_image_file_name" {
  type        = string
  description = "Optional file name for Talos image in Proxmox storage"
  default     = null
}

variable "kubernetes_version" {
  type        = string
  description = "Kubernetes version for generated machine configuration"
  default     = null
}
