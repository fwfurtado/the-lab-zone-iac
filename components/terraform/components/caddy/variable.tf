variable "stage" {
  type = string
  description = "The stage of the stack"
}

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
  })
  description = "The Docker configuration"
}

variable "truenas" {
  type = object({
    host = string
    username = string
    private_key = string
    fingerprint = string
  })
  description = "The Truenas configuration"
}
