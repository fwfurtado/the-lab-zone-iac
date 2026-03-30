variable "stage" {
  type        = string
  description = "Stage (e.g. infra)"
  default     = "infra"
}

variable "proxmox_node_name" {
  type        = string
  description = "The name of the Proxmox node"
}

variable "proxmox_ssh_host" {
  type        = string
  description = "SSH host/IP for the Proxmox node"
}

variable "proxmox_ssh_username" {
  type        = string
  description = "SSH username for the Proxmox node"
  default     = "root"
}

variable "vm_id" {
  type        = number
  description = "Proxmox VM ID"
}

variable "vm_name" {
  type        = string
  description = "VM hostname"
  default     = "truenas"
}

variable "vm_description" {
  type        = string
  description = "VM description"
  default     = "TrueNAS SCALE NAS with ZFS"
}

variable "cpu" {
  type        = number
  description = "Number of CPU cores"
  default     = 2
}

variable "memory" {
  type        = number
  description = "Memory in MB"
  default     = 8192
}

variable "os_disk_size" {
  type        = number
  description = "OS disk size in GB"
  default     = 32
}

variable "datastore_id" {
  type        = string
  description = "Proxmox datastore for VM disks"
  default     = "local-ssd"
}

variable "iso_path" {
  type        = string
  description = "Local path to the TrueNAS SCALE ISO file"
}

variable "tags" {
  type        = list(string)
  description = "VM tags"
  default     = ["nas", "truenas", "storage"]
}
