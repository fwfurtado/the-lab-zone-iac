output "image" {
  value = {
    id = docker_image.this.image_id
    name = local.full_image_ref
    sha256_digest = docker_registry_image.this.sha256_digest
  }
}
