data "talos_image_factory_extensions_versions" "this" {
  talos_version = var.talos_version
  filters = {
    names = var.talos_image_extensions
  }
}

resource "talos_image_factory_schematic" "this" {
  schematic = length(var.talos_image_extensions) == 0 ? null : yamlencode({
    customization = {
      systemExtensions = {
        officialExtensions = try(data.talos_image_factory_extensions_versions.this.extensions_info[*].name, [])
      }
    }
  })

  lifecycle {
    precondition {
      condition     = length(local.missing_extensions) == 0
      error_message = "Some talos_image_extensions were not found for talos_version ${var.talos_version}: ${join(", ", tolist(local.missing_extensions))}"
    }
  }
}

data "talos_image_factory_urls" "this" {
  schematic_id  = talos_image_factory_schematic.this.id
  talos_version = var.talos_version
  platform      = var.talos_image_platform
  architecture  = var.talos_image_architecture
  sbc           = var.talos_image_sbc
}

resource "proxmox_virtual_environment_download_file" "talos_iso" {
  content_type = "iso"
  datastore_id = var.talos_image_datastore_id
  node_name    = var.proxmox_node_name
  url          = data.talos_image_factory_urls.this.urls.iso
  file_name    = var.talos_image_file_name
}
