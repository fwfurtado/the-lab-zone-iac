module "this" {
  source = "../../modules/talos-cluster"

  proxmox_node_name = var.proxmox_node_name
  defaults          = var.defaults

  cluster               = var.cluster
  nodes                 = var.nodes
  talos_iso_file_id      = var.talos_iso_file_id
  operating_system_type  = var.operating_system_type
}
