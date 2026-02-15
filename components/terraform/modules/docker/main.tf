resource "docker_image" "this" {
  name = local.full_image_ref

  build {
    context    = var.context
    dockerfile = var.dockerfile
    platform   = var.platform
    builder = null

    build_args = var.build_args
  }

  triggers = merge(
    {
      dockerfile = sha1(var.dockerfile)
      context = sha1(join("", [ for file in fileset(var.context, "**") : filesha1(file) ]))
    }
  )
}


resource "docker_registry_image" "this" {
  name                 = docker_image.this.name
  keep_remotely        = true
  insecure_skip_verify = true

  depends_on = [docker_image.this]
}
