locals {
  full_image_ref = var.image.registry != null ? "${var.image.registry}/${var.image.repository}:${var.image.tag}" : "${var.image.repository}:${var.image.tag}"
}
