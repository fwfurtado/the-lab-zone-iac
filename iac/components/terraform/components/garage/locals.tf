locals {
  servers = {
    for server in var.garage.servers : server.id => merge(server, { ip_address = split("/", server.ip_cidr)[0] })
  }

  ui_servers = {
    for ui in var.garage.ui : ui.id => merge(ui, { ip_address = split("/", ui.ip_cidr)[0] })
  }
}
