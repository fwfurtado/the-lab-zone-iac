output "database_name" {
  value = postgresql_database.this.name
}

output "database_user" {
  value = postgresql_role.this.name
}

output "database_host" {
  value = var.postgresql_host
}

output "database_port" {
  value = var.postgresql_port
}
