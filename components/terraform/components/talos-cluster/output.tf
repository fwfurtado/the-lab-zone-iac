output "vm_group" {
  value = module.vm
}

output "talos_cluster" {
  value = {
    endpoint                        = local.cluster_endpoint
    controlplane_ips                = local.controlplane_ips
    worker_ips                      = local.worker_ips
    talosconfig                     = data.talos_client_configuration.this.talos_config
    kubeconfig_raw                  = talos_cluster_kubeconfig.this.kubeconfig_raw
    talos_image_extensions_resolved = local.resolved_extensions
    talos_image_extensions_missing  = tolist(local.missing_extensions)
  }
  sensitive = true
}


output "talos_image_factory_schematic" {
  value = talos_image_factory_schematic.this.schematic
}

output "talos_image_factory_urls" {
  value = data.talos_image_factory_urls.this.urls
}

output "kubeconfig_raw" {
  value = talos_cluster_kubeconfig.this.kubeconfig_raw
  sensitive = true
}
