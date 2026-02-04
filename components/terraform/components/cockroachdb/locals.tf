locals {

  ips = { for server in var.cockroachdb.servers : server.id => split("/", server.ip_cidr)[0] }
  join_addresses = join(",", [for server in var.cockroachdb.servers : split("/", server.ip_cidr)[0]])
}
