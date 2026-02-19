variable "stage" {
  type        = string
  description = "The stage of the stack"
}

variable "app" {
  type = object({
    name        = string
    description = optional(string)

    compose = object({
      # Either provide the compose YAML inline or as a template file path
      content = optional(string)
      vars    = optional(map(string), {})
    })

    datasets = optional(list(object({
      path        = string
      pool        = optional(string)
      compression = optional(string)
      quota       = optional(string)
      mode        = optional(string)
      uid         = optional(number, 568)
      gid         = optional(number, 568)
    })), [])

    config_files = optional(list(object({
      # Path inside the TrueNAS filesystem (absolute)
      path    = string
      content = string
      mode    = optional(string, "0644")
    })), [])

    network = optional(object({
      ip   = optional(string)
      port = optional(number)
    }))
  })
  description = "The TrueNAS custom app configuration"
}

variable "defaults" {
  type = object({
    pool = optional(string, "paradise")
  })
  default = {}
}

variable "truenas_ssh_host" {
  type        = string
  description = "The SSH host of the TrueNAS instance"
}

variable "truenas_ssh_port" {
  type        = number
  description = "The SSH port of the TrueNAS instance"
}

variable "truenas_ssh_username" {
  type        = string
  description = "The SSH username of the TrueNAS instance"
}

variable "truenas_ssh_host_key_fingerprint" {
  type        = string
  description = "The SSH host key fingerprint of the TrueNAS instance"
}

variable "truenas_ssh_private_key" {
  type        = string
  description = "The SSH private key of the TrueNAS instance"
}
