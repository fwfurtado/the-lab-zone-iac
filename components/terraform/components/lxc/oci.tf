locals {
  oci_image_file_name = "${replace(local.container.image.registry, ".", "_")}-${replace(local.container.image.repository, "/", "_")}-${local.container.image.tag}.tar"
}

resource "proxmox_virtual_environment_oci_image" "this" {
  node_name    = local.proxmox.node.name
  datastore_id = local.container.image.storage_id
  reference    = "${local.container.image.registry}/${local.container.image.repository}:${local.container.image.tag}"

  upload_timeout      = 300
  overwrite           = false
  overwrite_unmanaged = true

  file_name = local.oci_image_file_name
}

