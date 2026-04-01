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
  default     = "pbs"
}

variable "vm_description" {
  type        = string
  description = "VM description"
  default     = "Proxmox Backup Server"
}

variable "cpu" {
  type        = number
  description = "Number of CPU cores"
  default     = 2
}

variable "memory" {
  type        = number
  description = "Memory in MB"
  default     = 2048
}

variable "os_disk_size" {
  type        = number
  description = "OS disk size in GB"
  default     = 16
}

variable "cache_disk_size" {
  type        = number
  description = "S3 cache disk size in GB"
  default     = 50
}

variable "datastore_id" {
  type        = string
  description = "Proxmox datastore for VM disks"
  default     = "local-ssd"
}

variable "iso_path" {
  type        = string
  description = "Local path to the Proxmox Backup Server ISO file"
}

variable "tags" {
  type        = list(string)
  description = "VM tags"
  default     = ["backup", "pbs"]
}
