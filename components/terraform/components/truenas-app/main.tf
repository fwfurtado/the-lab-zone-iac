# =============================================================================
# Datasets
# =============================================================================

# =============================================================================
# Datasets - depth 1 (e.g. "tailscale")
# =============================================================================
resource "truenas_dataset" "depth_1" {
  for_each = {
    for k, v in local.datasets : k => v
    if v.depth == 1
  }

  pool        = each.value.pool
  path        = each.value.full_path
  compression = each.value.compression
  quota       = each.value.quota
  mode        = each.value.mode
  uid         = each.value.uid
  gid         = each.value.gid
}

# =============================================================================
# Datasets - depth 2 (e.g. "tailscale/data")
# =============================================================================
resource "truenas_dataset" "depth_2" {
  for_each = {
    for k, v in local.datasets : k => v
    if v.depth == 2
  }

  pool        = each.value.pool
  path        = each.value.full_path
  compression = each.value.compression
  quota       = each.value.quota
  mode        = each.value.mode
  uid         = each.value.uid
  gid         = each.value.gid

  depends_on = [truenas_dataset.depth_1]
}

# =============================================================================
# Configuration Files
# =============================================================================

resource "truenas_file" "this" {
  for_each = local.config_files

  path    = each.value.path
  content = each.value.content
  mode    = each.value.mode

  depends_on = [truenas_dataset.depth_1, truenas_dataset.depth_2]

}

# =============================================================================
# Custom App
# =============================================================================


resource "truenas_app" "this" {
  name           = var.app.name
  custom_app     = true
  compose_config = local.compose_config

  depends_on = [
    truenas_dataset.depth_1,
    truenas_dataset.depth_2,
    truenas_file.this,
  ]
}
