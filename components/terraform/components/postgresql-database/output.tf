output "databases" {
  value = {
    for name, db in postgresql_database.this : name => {
      name = db.name
      user = postgresql_role.this[name].name
      host = var.postgresql_host
      port = var.postgresql_port
    }
  }
}
