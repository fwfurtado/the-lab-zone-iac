variable "vault" {
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
