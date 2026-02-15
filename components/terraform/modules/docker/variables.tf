variable "provider" {
  type        = optional(object({
    docker_host = string
    ssh_opts = optional(list(string))
    registry_auth = optional(object({
      address = string
      username = string
      password = string
    }))
  }))

  description = "The provider configuration"
  default     = null
}

variable "image" {
  type = object({
    registry = optional(string)
    repository = string
    tag = string
  })
  description = "The image configuration"
}

variable "context" {
  type        = string
  description = "The context of the image"
}

variable "dockerfile" {
  type        = string
  description = "The Dockerfile of the image"
}

variable "platform" {
  type        = string
  description = "The platform of the image"
}

variable "build_args" {
  type        = map(string)
  description = "The build args of the image"
}
