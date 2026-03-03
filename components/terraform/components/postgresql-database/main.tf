provider "postgresql" {
  host     = var.postgresql_host
  port     = var.postgresql_port
  username = "postgres"
  password = var.postgresql_admin_password
  sslmode  = "disable"
}

resource "postgresql_role" "this" {
  name     = var.database_user
  login    = true
  password = var.database_password
}

resource "postgresql_database" "this" {
  name  = var.database_name
  owner = postgresql_role.this.name
}
