locals {
  pool              = var.defaults.pool
  dataset_base_path = "the-lab-zone/stateful-apps"

  compose_config = templatestring(var.app.compose.content, var.app.compose.vars)

  datasets = {
    for ds in var.app.datasets : ds.path => {
      full_path   = "${local.dataset_base_path}/${ds.path}"
      pool        = coalesce(ds.pool, local.pool)
      compression = ds.compression
      quota       = ds.quota
      mode        = coalesce(ds.mode, "755")
      uid         = ds.uid
      gid         = ds.gid
      depth       = length(split("/", ds.path))
    }
  }

  # Normalize config files
  config_files = {
    for f in var.app.config_files :
    f.path => f
  }
}
