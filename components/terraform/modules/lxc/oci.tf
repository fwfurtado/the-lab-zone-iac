module "oci-image-download" {
  source = "../oci-image-download"

  registry   = local.container.image.registry
  repository = local.container.image.repository
  tag        = local.container.image.tag

  proxmox = {
    node = {
      name = local.proxmox.node.name
    }
  }

  storage = {
    id = local.container.image.storage_id
  }
}
