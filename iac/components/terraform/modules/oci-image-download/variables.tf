variable "proxmox" {
  type        = object({
    node = object({
      name = string
    })
  })
  description = "The Proxmox configuration"
}

variable "storage" {
  description = "The storage for OCI images"
  type        = object({
    id = string
  })

  default = {
    id = "local"
  }

}

variable "registry" {
  type        = string
  description = "The registry of the image"
  default = "docker.io"
}

variable "repository" {
  type        = string
  description = "The repository of the image"
}

variable "tag" {
  type        = string
  description = "The tag of the image"
}

variable "upload_timeout" {
  type        = number
  description = "The upload timeout of the image"
  default = 300
}

variable "overwrite" {
  type        = bool
  description = "The overwrite of the image"
  default = false
}

variable "overwrite_unmanaged" {
  type        = bool
  description = "The overwrite unmanaged of the image"
  default = true
}