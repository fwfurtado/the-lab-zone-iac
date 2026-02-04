variable "stage" {
  type        = string
  description = "The stage of the deployment"
}

variable "proxmox_node_name" {
  type        = string
  description = "The name of the Proxmox node"
}

variable "defaults" {
  type        = any
  description = "Default values for VMs"
}

variable "cluster_endpoint" {
  type        = string
  description = "Talos cluster endpoint URL (defaults to first controlplane node)"
  default     = null
}

variable "talos_install_disk" {
  type        = string
  description = "Disk device for Talos installation"
  default     = "/dev/sda"
}
