variable "stage" {
  type = string
  description = "The stage of the deployment"
}

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
  type = any
  description = "The container configuration - see modules/lxc/variables.tf for more details"
}

variable "defaults" {
  type = any
  description = "The defaults configuration - see modules/lxc/variables.tf for more details"
}