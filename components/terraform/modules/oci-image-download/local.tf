locals {
  file_name = "${replace(var.registry, ".", "_")}__${replace(var.repository, "/", "_")}-${var.tag}.tar"
}