locals {
  file_name = "${replace(var.registry, ".", "_")}-${replace(var.repository, "/", "_")}-${var.tag}.tar"
}