variable "stage" {
  type        = string
  description = "The stage of the stack"
}

variable "garage_host" {
  type        = string
  description = "Garage admin API endpoint (host:port)"
}

variable "garage_admin_token" {
  type        = string
  description = "Garage admin API token"
  sensitive   = true
}

variable "nodes" {
  type = list(object({
    id       = string
    zone     = string
    capacity = string
    tags     = optional(list(string), [])
  }))
  description = "Cluster node roles for layout"
  default     = []
}

variable "keys" {
  type = map(object({
    bucket_names = list(string)
  }))
  description = "Map of key_name => { bucket_names } to create and bind"
}

variable "buckets" {
  type = map(object({
    website         = optional(bool, false)
    expiration_days = optional(number, 0)
  }))
  description = "Map of bucket_name => { website, expiration_days } to create"
}
