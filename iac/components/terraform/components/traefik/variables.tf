variable "traefik" {
  type = object({
    id          = number
    hostname    = string
    description = string
    ip_cidr     = string
    dns = object({
      servers = list(string)
    })
  })
  description = "The traefik configurations"
}

variable "cloudflare_api_key" {
  type        = string
  description = "The API key for the Cloudflare"
  sensitive   = true
}
