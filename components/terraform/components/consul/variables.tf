variable "consul" {
  type = object({
    datacenter = string
    data_dir   = string
    servers = list(object({
      id       = number
      hostname = string
      description = string
      ip_cidr  = string
    }))
    esm = list(object({
      id       = number
      hostname = string
      description = string
      ip_cidr  = string
    }))
  })
  description = "The consul configurations"
}


variable "consul_esm_token" {
  type = string
  description = "The token for the Consul ESM"
}