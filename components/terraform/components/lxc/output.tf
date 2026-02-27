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

output "template" {
  value = {
    id        = proxmox_virtual_environment_file.template.id
    file_name = proxmox_virtual_environment_file.template.file_name
  }
}
