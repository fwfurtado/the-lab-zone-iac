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
