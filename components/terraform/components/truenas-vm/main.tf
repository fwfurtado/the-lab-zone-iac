resource "proxmox_virtual_environment_file" "truenas_iso" {
  content_type = "iso"
  datastore_id = "local"
  node_name    = var.proxmox_node_name

  source_file {
    path = var.iso_path
  }
}

resource "proxmox_virtual_environment_vm" "this" {
  depends_on = [proxmox_virtual_environment_file.truenas_iso]

  name        = var.vm_name
  description = var.vm_description
  tags        = sort(var.tags)
  node_name   = var.proxmox_node_name
  vm_id       = var.vm_id

  agent {
    enabled = true
  }

  stop_on_destroy = true
  started         = true
  on_boot         = true

  cpu {
    cores = var.cpu
    type  = "host"
  }

  memory {
    dedicated = var.memory
  }

  # OS disk (TrueNAS will be installed here via the ISO installer)
  disk {
    datastore_id = var.datastore_id
    interface    = "scsi0"
    size         = var.os_disk_size
    file_format  = "raw"
  }

  # TrueNAS ISO mounted as CDROM
  cdrom {
    enabled   = true
    file_id   = proxmox_virtual_environment_file.truenas_iso.id
    interface = "ide2"
  }

  # IronWolf disk passthrough is added manually via Proxmox CLI.
  # Identify disk IDs on the Proxmox host:
  #   ls -la /dev/disk/by-id/ | grep -i ST4000VN006
  #
  # Then attach each disk (serial= is required for TrueNAS to distinguish disks):
  #   qm set 1104 -scsi1 /dev/disk/by-id/ata-ST4000VN006-3CW104_ZW63SW5M,serial=ZW63SW5M
  #   qm set 1104 -scsi2 /dev/disk/by-id/ata-ST4000VN006-3CW104_ZW63BDS4,serial=ZW63BDS4
  #   qm set 1104 -scsi3 /dev/disk/by-id/ata-ST4000VN006-3CW104_ZW63SWD4,serial=ZW63SWD4

  network_device {
    bridge = "vmbr0"
  }

  # No cloud-init -- TrueNAS is installed interactively via the ISO console.
  # After installation, configure the static IP via the TrueNAS web UI or console.

  operating_system {
    type = "l26"
  }

  # First boot: scsi0 is empty, falls through to ide2 (ISO installer).
  # After installation: scsi0 has TrueNAS, boots from disk.
  boot_order = ["scsi0", "ide2"]

  lifecycle {
    ignore_changes = [
      network_device[0].mac_address,
      disk,
      cdrom,
    ]
  }
}
