variable "tailscale" {
  type = object({
    id          = number
    hostname    = string
    description = string
    ip_cidr     = string
    routes      = list(string)
  })
  description = "The tailscale configurations"
}

variable "ts_authkey" {
  type        = string
  description = "The authkey for the Tailscale"
  sensitive   = true
}
