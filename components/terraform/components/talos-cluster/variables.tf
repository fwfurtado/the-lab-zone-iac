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
    name            = string
    id              = number
    role            = string
    cpu             = number
    memory          = number
    disk_size       = number
    datastore_id    = optional(string)
    network_bridge  = optional(string)
    ip_cidr         = string
    static_ip_cidr  = optional(string)
    started         = optional(bool)
    on_boot         = optional(bool)
    tags            = optional(list(string), [])
  }))
  description = <<-EOD
    Talos nodes. ip_cidr is the address used to connect (and the expected address after config).
    Set static_ip_cidr when the node currently has a different IP (e.g. DHCP): use ip_cidr for
    the current/bootstrap IP and static_ip_cidr for the static IP to configure in Talos.
  EOD

  validation {
    condition     = length([for node in var.nodes : node if node.role == "controlplane"]) > 0
    error_message = "At least one controlplane node is required."
  }
}

variable "node_network_gateway" {
  type        = string
  description = "Default gateway for node static network config (e.g. 10.40.0.1). Required for static IP patch."
  default     = "10.40.0.1"
}

variable "node_network_interface" {
  type        = string
  description = "Interface name for static network config (e.g. eth0)"
  default     = "eth0"
}

variable "operating_system_type" {
  type        = string
  description = "The Proxmox OS type for the VM"
  default     = "l26"
}

variable "vm_cpu_type" {
  type        = string
  description = "Proxmox/QEMU CPU type for VMs. Talos 1.7+ requires x86-64 microarchitecture level 2+ (e.g. x86-64-v2-AES); qemu64 is level 1."
  default     = "x86-64-v2-AES"
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

variable "image_registry_username" {
  type        = string
  description = "Username for image registry k8s user"
  default     = "k8s"
}

variable "image_registry_password" {
  type        = string
  description = "Password for image registry k8s user"
  sensitive   = true
  default     = ""
}
