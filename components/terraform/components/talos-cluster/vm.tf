module "vm" {
  source = "../../modules/vm"

  proxmox_node_name = var.proxmox_node_name
  defaults          = var.defaults

  group = local.cluster
  vms   = local.vms

  operating_system_type = var.operating_system_type
  cdrom = {
    enabled   = true
    file_id   = proxmox_virtual_environment_download_file.talos_iso.id
    interface = "ide2"
  }
  boot_order = ["scsi0", "ide2"]
}
