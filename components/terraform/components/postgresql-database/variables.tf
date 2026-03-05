variable "stage" {
  type        = string
  description = "The stage of the stack"
}

variable "postgresql_host" {
  type        = string
  description = "The hostname or IP of the PostgreSQL server"
}

variable "postgresql_port" {
  type        = number
  description = "The port of the PostgreSQL server"
  default     = 5432
}

variable "postgresql_admin_password" {
  type        = string
  description = "The password for the PostgreSQL admin (postgres) user"
  sensitive   = true
}

variable "databases" {
  type = map(object({
    user     = string
    password = string
  }))
  description = "Map of database_name => { user, password } to create"
}
