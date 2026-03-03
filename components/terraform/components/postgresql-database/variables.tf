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

variable "database_name" {
  type        = string
  description = "The name of the database to create"
}

variable "database_user" {
  type        = string
  description = "The name of the role to create as owner of the database"
}

variable "database_password" {
  type        = string
  description = "The password for the database role"
  sensitive   = true
}
