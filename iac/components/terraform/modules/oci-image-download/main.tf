
resource "proxmox_virtual_environment_oci_image" "this" {
  node_name    = var.proxmox.node.name
  datastore_id = var.storage.id
  reference    = "${var.registry}/${var.repository}:${var.tag}"

  upload_timeout      = var.upload_timeout
  overwrite           = var.overwrite
  overwrite_unmanaged = var.overwrite_unmanaged

  file_name = local.file_name
}