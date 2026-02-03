variable "cockroachdb" {
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
    }
  )
  description = "The vault configurations"
}


variable "cockroachdb_enterprise_license" {
  type        = string
  description = "The enterprise license for the CockroachDB"
  sensitive   = true
}

variable "cockroachdb_cluster_organization" {
  type        = string
  description = "The organization for the CockroachDB cluster"
}
