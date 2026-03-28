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
  default     = "patroni-pg"
}

variable "vm_description" {
  type        = string
  description = "VM description"
  default     = "Patroni HA PostgreSQL 16 with PgBouncer and PgBackRest"
}

variable "ip_cidr" {
  type        = string
  description = "Static IP in CIDR notation (e.g. 10.40.1.75/21)"
}

variable "gateway" {
  type        = string
  description = "Network gateway"
  default     = "10.40.0.1"
}

variable "cpu" {
  type        = number
  description = "Number of CPU cores"
  default     = 4
}

variable "memory" {
  type        = number
  description = "Memory in MB"
  default     = 8192
}

variable "os_disk_size" {
  type        = number
  description = "OS disk size in GB"
  default     = 20
}

variable "data_disk_size" {
  type        = number
  description = "PostgreSQL data disk size in GB"
  default     = 100
}

variable "datastore_id" {
  type        = string
  description = "Proxmox datastore for VM disks"
  default     = "local-ssd"
}

variable "cloud_image_url" {
  type        = string
  description = "URL to the Debian cloud image"
  default     = "https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-generic-amd64.qcow2"
}

variable "ssh_public_keys" {
  type        = list(string)
  description = "SSH public keys for cloud-init"
}

variable "tags" {
  type        = list(string)
  description = "VM tags"
  default     = ["database", "patroni", "postgresql"]
}
