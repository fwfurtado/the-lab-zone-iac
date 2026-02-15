output "all" {
  value = {
    # id = truenas_app.this.id
    # name = truenas_app.this.name
    # compose_config = truenas_app.this.compose_config
    datasets = truenas_dataset.this
    # files = truenas_file.this
  }
}
