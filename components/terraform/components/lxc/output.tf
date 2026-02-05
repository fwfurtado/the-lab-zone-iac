output "id" {
  value = proxmox_virtual_environment_container.this.id
}

output "vm_id" {
  value = local.container.id
}

output "name" {
  value = local.container.hostname
}

output "ip_cidr" {
  value = local.container.network.ip_cidr
}

output "image" {
  value = {
    id        = proxmox_virtual_environment_oci_image.this.id
    name      = proxmox_virtual_environment_oci_image.this.reference
    file_name = proxmox_virtual_environment_oci_image.this.file_name
  }
}

output "entrypoint" {
  value = local.container.entrypoint
}

