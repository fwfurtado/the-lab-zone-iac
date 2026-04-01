resource "proxmox_virtual_environment_file" "pbs_iso" {
  content_type = "iso"
  datastore_id = "local"
  node_name    = var.proxmox_node_name

  source_file {
    path = var.iso_path
  }
}

resource "proxmox_virtual_environment_vm" "this" {
  depends_on = [proxmox_virtual_environment_file.pbs_iso]

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

  # OS disk (PBS will be installed here via the ISO installer)
  disk {
    datastore_id = var.datastore_id
    interface    = "scsi0"
    size         = var.os_disk_size
    file_format  = "raw"
  }

  # S3 cache disk
  # After first boot, format and mount inside the VM:
  #   mkfs.ext4 /dev/sdb
  #   mkdir -p /mnt/s3-cache
  #   echo "/dev/sdb /mnt/s3-cache ext4 defaults 0 0" >> /etc/fstab
  #   mount -a
  disk {
    datastore_id = var.datastore_id
    interface    = "scsi1"
    size         = var.cache_disk_size
    file_format  = "raw"
  }

  # PBS ISO mounted as CDROM
  cdrom {
    enabled   = true
    file_id   = proxmox_virtual_environment_file.pbs_iso.id
    interface = "ide2"
  }

  network_device {
    bridge = "vmbr0"
  }

  # No cloud-init -- PBS is installed interactively via the ISO console.
  # After installation, the web UI is available at https://<ip>:8007

  operating_system {
    type = "l26"
  }

  # First boot: scsi0 is empty, falls through to ide2 (ISO installer).
  # After installation: scsi0 has PBS, boots from disk.
  boot_order = ["scsi0", "ide2"]

  lifecycle {
    ignore_changes = [
      network_device[0].mac_address,
      disk,
      cdrom,
    ]
  }
}
