variable "garage" {
  type = object(
    {
      servers = list(
        object(
          {
            id          = number
            hostname    = string
            description = string
            ip_cidr     = string
          }
        )
      )
      ui = list(
        object(
          {
            id          = number
            hostname    = string
            description = string
            ip_cidr     = string
          }
        )
      )
    }
  )
  description = "The garage configurations"
}


variable "garage_rpc_secret" {
  type        = string
  description = "The RPC secret for Garage cluster communication (32 bytes hex)"
  sensitive   = true
}

variable "garage_admin_token" {
  type        = string
  description = "The admin API token for Garage"
  sensitive   = true
}

variable "garage_metrics_token" {
  type        = string
  description = "The metrics endpoint token for Garage"
  sensitive   = true
}
