resource "truenas_dataset" "this" {
  count = length(var.datasets)

  parent = var.datasets[count.index].parent
  path = var.datasets[count.index].path
  uid  = var.datasets[count.index].uid
  gid  = var.datasets[count.index].gid
  mode = var.datasets[count.index].mode
}

# resource "truenas_file" "this" {
#   for_each = var.files

#   host_path     = truenas_dataset.this[dirname(each.key)].id
#   relative_path = basename(each.key)
#   content       = each.value.content
#   mode          = coalesce(each.value.mode, "0644")
# }


# resource "truenas_app" "this" {
#   depends_on = [truenas_dataset.this, truenas_file.this]

#   name       = var.name
#   custom_app = true

#   compose_config = yamlencode(var.compose)
# }
