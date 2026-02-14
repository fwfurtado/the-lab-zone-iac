# Talos provider connects to each node at <node_ip>:50000 (Talos API).
# The host running Terraform must have network route to the node IPs (e.g. same LAN,
# Tailscale subnet router, or VPN). Otherwise you get "no route to host" on apply.
resource "talos_machine_secrets" "this" {}

data "talos_machine_configuration" "controlplane" {
  cluster_name       = var.cluster.name
  machine_type       = "controlplane"
  cluster_endpoint   = local.cluster_endpoint
  machine_secrets    = talos_machine_secrets.this.machine_secrets
  talos_version      = var.talos_version
  kubernetes_version = var.kubernetes_version
}

data "talos_machine_configuration" "worker" {
  cluster_name       = var.cluster.name
  machine_type       = "worker"
  cluster_endpoint   = local.cluster_endpoint
  machine_secrets    = talos_machine_secrets.this.machine_secrets
  talos_version      = var.talos_version
  kubernetes_version = var.kubernetes_version
}

data "talos_client_configuration" "this" {
  cluster_name         = var.cluster.name
  client_configuration = talos_machine_secrets.this.client_configuration
  nodes                = local.controlplane_ips
}

resource "talos_machine_configuration_apply" "nodes" {
  for_each = local.nodes_by_name

  client_configuration        = talos_machine_secrets.this.client_configuration
  machine_configuration_input = each.value.role == "controlplane" ? data.talos_machine_configuration.controlplane.machine_configuration : data.talos_machine_configuration.worker.machine_configuration
  node                        = each.value.ip
  config_patches = compact(concat(
    var.talos_config_patches,
    [local.install_disk_patch],
    [local.registry_config_patch],
    try([local.network_patches[each.key]], []),
    each.value.role == "controlplane" ? var.controlplane_config_patches : var.worker_config_patches
  ))


  depends_on = [module.vm]
}

resource "talos_machine_bootstrap" "this" {
  depends_on = [talos_machine_configuration_apply.nodes]

  node                 = local.controlplane_ips[0]
  client_configuration = talos_machine_secrets.this.client_configuration
}

resource "talos_cluster_kubeconfig" "this" {
  depends_on = [talos_machine_bootstrap.this]

  node                 = local.controlplane_ips[0]
  client_configuration = talos_machine_secrets.this.client_configuration
}
