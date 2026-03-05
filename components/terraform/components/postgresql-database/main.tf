provider "postgresql" {
  host     = var.postgresql_host
  port     = var.postgresql_port
  username = "postgres"
  password = var.postgresql_admin_password
  sslmode  = "disable"
}

resource "postgresql_role" "this" {
  for_each = var.databases
  name     = each.value.user
  login    = true
  password = each.value.password
}

resource "postgresql_database" "this" {
  for_each = var.databases
  name     = each.key
  owner    = postgresql_role.this[each.key].name
}
