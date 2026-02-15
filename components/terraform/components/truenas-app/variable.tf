variable "docker" {
  type = object({
    image = object({
      repository = string
      tag        = string
      registry   = optional(string, null)
    })
    provider = optional(object({
      docker_host = string
      ssh_opts = optional(list(string), null)
      registry_auth = optional(object({
        address = string
        username = string
        password = string
      }))
    }))

    context = string
    dockerfile = string
    platform = string
    build_args = optional(map(string), null)
  })
  description = "The Docker configuration"
}
