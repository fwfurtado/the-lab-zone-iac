resource "proxmox_virtual_environment_download_file" "cloud_image" {
  content_type = "iso"
  datastore_id = "local"
  node_name    = var.proxmox_node_name
  url          = var.cloud_image_url
  file_name    = "debian-12-generic-amd64.img"
  overwrite    = false
}

resource "proxmox_virtual_environment_vm" "this" {
  depends_on = [proxmox_virtual_environment_download_file.cloud_image]

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

  # OS disk
  disk {
    datastore_id = var.datastore_id
    interface    = "scsi0"
    size         = var.os_disk_size
    file_id      = proxmox_virtual_environment_download_file.cloud_image.id
  }

  # PostgreSQL data disk is added manually via:
  #   qm set <vmid> --scsi1 <datastore>:<size>,format=raw
  # e.g.: qm set 1175 --scsi1 local-ssd:100,format=raw

  network_device {
    bridge = "vmbr0"
  }

  initialization {
    datastore_id = var.datastore_id
    interface    = "ide0"

    user_account {
      keys     = var.ssh_public_keys
      username = "debian"
    }

    ip_config {
      ipv4 {
        address = var.ip_cidr
        gateway = var.gateway
      }
    }
  }

  operating_system {
    type = "l26"
  }

  boot_order = ["scsi0"]

  lifecycle {
    ignore_changes = [
      network_device[0].mac_address,
      disk,
    ]
  }
}
