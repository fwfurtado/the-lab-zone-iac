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
  value = module.oci-image-download
}

output "entrypoint" {
  value = local.container.entrypoint
}