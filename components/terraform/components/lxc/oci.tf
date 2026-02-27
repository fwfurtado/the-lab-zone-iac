resource "proxmox_virtual_environment_file" "template" {
  content_type = "vztmpl"
  datastore_id = local.container.image.storage_id
  node_name    = local.proxmox.node.name
  overwrite = true

  source_file {
    path = abspath("${path.root}/../../../../${var.template_file}")
    checksum = filesha256(abspath("${path.root}/../../../../${var.template_file}"))
  }
}
