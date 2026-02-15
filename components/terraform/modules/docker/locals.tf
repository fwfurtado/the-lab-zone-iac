locals {
  registry       = var.image.registry != null ? replace(replace(var.image.registry, "https://", ""), "http://", "") : null
  full_image_ref = local.registry != null ? "${local.registry}/${var.image.repository}:${var.image.tag}" : "${var.image.repository}:${var.image.tag}"
}
