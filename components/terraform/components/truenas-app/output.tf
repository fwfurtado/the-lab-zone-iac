output "app" {
  value = {
    name = truenas_app.this.name
    id   = truenas_app.this.id
  }
}

output "datasets" {
  value = merge(
    {
      for k, v in truenas_dataset.depth_1 : k => {
        id        = v.id
        path      = v.path
        pool      = v.pool
        full_path = v.full_path
      }
    },
    {
      for k, v in truenas_dataset.depth_2 : k => {
        id        = v.id
        path      = v.path
        pool      = v.pool
        full_path = v.full_path
      }
    }
  )
}
